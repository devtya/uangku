import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uangku/core/database/app_database.dart';

/// Last-write-wins: terapkan data remote hanya jika lebih baru dari lokal.
/// Fungsi murni supaya mudah dites.
bool shouldApplyRemote(DateTime? local, DateTime remote) =>
    local == null || remote.isAfter(local);

/// Sinkronisasi offline-first: Drift tetap source of truth.
/// - pull saat login & reconnect
/// - push perubahan lokal (row isSynced=false) secara debounced
/// Konflik diselesaikan last-write-wins berdasarkan updatedAt.
class SyncService {
  final AppDatabase _db;
  final FirebaseFirestore _firestore;
  final Connectivity _connectivity;

  SyncService(this._db, this._firestore, this._connectivity);

  String? _uid;
  bool _busy = false;
  StreamSubscription<void>? _tableSub;
  StreamSubscription<List<ConnectivityResult>>? _connSub;
  Timer? _pushDebounce;

  Future<void> handleLogin(String uid) async {
    _uid = uid;

    // Deteksi ganti akun: kalau data lokal milik uid lain, bersihkan dulu.
    final lastUid = await _getMeta('lastUid');
    if (lastUid != null && lastUid != uid) {
      await _clearLocal();
    }
    await _setMeta('lastUid', uid);

    _tableSub ??= _db.tableUpdates().listen((_) => _schedulePush());
    _connSub ??= _connectivity.onConnectivityChanged.listen((results) {
      final online = results.any((r) => r != ConnectivityResult.none);
      if (online) _fullSync();
    });

    await _fullSync();
  }

  void handleLogout() {
    _uid = null;
    _tableSub?.cancel();
    _tableSub = null;
    _connSub?.cancel();
    _connSub = null;
    _pushDebounce?.cancel();
    // Data lokal sengaja TIDAK dihapus (sesuai kebijakan offline-first).
  }

  void _schedulePush() {
    _pushDebounce?.cancel();
    _pushDebounce = Timer(const Duration(seconds: 2), _pushDirty);
  }

  Future<void> _fullSync() async {
    final uid = _uid;
    if (uid == null || _busy) return;
    _busy = true;
    try {
      await _pullAll(uid);
      await _pushAll(uid);
    } catch (_) {
      // Offline / transient — abaikan; retry saat reconnect atau perubahan berikut.
    } finally {
      _busy = false;
    }
  }

  Future<void> _pushDirty() async {
    final uid = _uid;
    if (uid == null || _busy) return;
    _busy = true;
    try {
      await _pushAll(uid);
    } catch (_) {
      // rows tetap isSynced=false → dicoba lagi nanti.
    } finally {
      _busy = false;
    }
  }

  // ---- PUSH ----

  Future<void> _pushAll(String uid) async {
    await _pushCollection<GajiTableData>(
      uid,
      'gaji',
      () => (_db.select(_db.gajiTable)..where((t) => t.isSynced.equals(false))).get(),
      (r) => r.id,
      _gajiToMap,
      (ids) => (_db.update(_db.gajiTable)..where((t) => t.id.isIn(ids)))
          .write(const GajiTableCompanion(isSynced: Value(true))),
    );
    await _pushCollection<PengeluaranTableData>(
      uid,
      'pengeluaran',
      () => (_db.select(_db.pengeluaranTable)
            ..where((t) => t.isSynced.equals(false)))
          .get(),
      (r) => r.id,
      _pengeluaranToMap,
      (ids) => (_db.update(_db.pengeluaranTable)..where((t) => t.id.isIn(ids)))
          .write(const PengeluaranTableCompanion(isSynced: Value(true))),
    );
    await _pushCollection<UtangTableData>(
      uid,
      'utang',
      () => (_db.select(_db.utangTable)..where((t) => t.isSynced.equals(false)))
          .get(),
      (r) => r.id,
      _utangToMap,
      (ids) => (_db.update(_db.utangTable)..where((t) => t.id.isIn(ids)))
          .write(const UtangTableCompanion(isSynced: Value(true))),
    );
    await _pushCollection<KategoriTableData>(
      uid,
      'kategori',
      () => (_db.select(_db.kategoriTable)
            ..where((t) => t.isSynced.equals(false)))
          .get(),
      (r) => r.id,
      _kategoriToMap,
      (ids) => (_db.update(_db.kategoriTable)..where((t) => t.id.isIn(ids)))
          .write(const KategoriTableCompanion(isSynced: Value(true))),
    );
    await _pushCollection<RecurringTableData>(
      uid,
      'recurring',
      () => (_db.select(_db.recurringTable)
            ..where((t) => t.isSynced.equals(false)))
          .get(),
      (r) => r.id,
      _recurringToMap,
      (ids) => (_db.update(_db.recurringTable)..where((t) => t.id.isIn(ids)))
          .write(const RecurringTableCompanion(isSynced: Value(true))),
    );
    await _pushAvatar(uid);
  }

  /// Kirim pilihan avatar ke doc `users/{uid}`. Foto galeri dikirim base64
  /// (dibatasi 512px q85 di picker, aman di bawah limit 1MB/doc Firestore).
  Future<void> _pushAvatar(String uid) async {
    if (await _getMeta('avatarSynced') == '1') return;
    final value = await _getMeta('avatar');
    if (value == null) return;
    final ts = int.tryParse(await _getMeta('avatarUpdatedAt') ?? '') ??
        DateTime.now().millisecondsSinceEpoch;

    final data = <String, dynamic>{'avatarUpdatedAt': ts};
    if (value.startsWith('file:')) {
      final dir = await getApplicationDocumentsDirectory();
      final f = File(p.join(dir.path, value.substring(5)));
      if (!await f.exists()) return; // file hilang, jangan tandai synced
      data['avatar'] = 'photo';
      data['avatarPhoto'] = base64Encode(await f.readAsBytes());
    } else {
      data['avatar'] = value; // 'google' / 'preset:..'
      data['avatarPhoto'] = FieldValue.delete();
    }
    await _avatarDoc(uid).set(data, SetOptions(merge: true));
    await _setMeta('avatarSynced', '1');
  }

  /// Doc avatar di subcollection (tercakup rule `users/{uid}/{document=**}`
  /// yang sama dengan data lain — tak perlu ubah Firestore rules).
  DocumentReference<Map<String, dynamic>> _avatarDoc(String uid) =>
      _firestore.collection('users').doc(uid).collection('meta').doc('profile');

  Future<void> _pushCollection<D>(
    String uid,
    String collection,
    Future<List<D>> Function() selectDirty,
    String Function(D) idOf,
    Map<String, dynamic> Function(D) toMap,
    Future<void> Function(List<String>) markSynced,
  ) async {
    final rows = await selectDirty();
    if (rows.isEmpty) return;
    final col = _firestore.collection('users').doc(uid).collection(collection);
    final batch = _firestore.batch();
    for (final r in rows) {
      batch.set(col.doc(idOf(r)), toMap(r));
    }
    await batch.commit();
    await markSynced([for (final r in rows) idOf(r)]);
  }

  // ---- PULL ----

  Future<void> _pullAll(String uid) async {
    await _pullCollection(uid, 'gaji', _upsertGaji);
    await _pullCollection(uid, 'pengeluaran', _upsertPengeluaran);
    await _pullCollection(uid, 'utang', _upsertUtang);
    await _pullCollection(uid, 'kategori', _upsertKategori);
    await _pullCollection(uid, 'recurring', _upsertRecurring);
    await _pullAvatar(uid);
  }

  Future<void> _pullAvatar(String uid) async {
    final snap = await _avatarDoc(uid).get();
    final d = snap.data();
    final remoteAvatar = d?['avatar'] as String?;
    if (d == null || remoteAvatar == null) return;
    final remoteTs = (d['avatarUpdatedAt'] as num?)?.toInt();
    if (remoteTs == null) return;

    final localTs = int.tryParse(await _getMeta('avatarUpdatedAt') ?? '');
    final localDt =
        localTs == null ? null : DateTime.fromMillisecondsSinceEpoch(localTs);
    if (!shouldApplyRemote(localDt, DateTime.fromMillisecondsSinceEpoch(remoteTs))) {
      return;
    }

    String value;
    if (remoteAvatar == 'photo') {
      final b64 = d['avatarPhoto'] as String?;
      if (b64 == null) return;
      await _deleteLocalAvatarFile();
      final dir = await getApplicationDocumentsDirectory();
      final name = 'avatar_$remoteTs.jpg';
      await File(p.join(dir.path, name)).writeAsBytes(base64Decode(b64));
      value = 'file:$name';
    } else {
      await _deleteLocalAvatarFile();
      value = remoteAvatar; // 'google' / 'preset:..'
    }

    await _setMeta('avatar', value);
    await _setMeta('avatarUpdatedAt', remoteTs.toString());
    await _setMeta('avatarSynced', '1'); // hindari echo-push
  }

  Future<void> _deleteLocalAvatarFile() async {
    final current = await _getMeta('avatar');
    if (current == null || !current.startsWith('file:')) return;
    try {
      final dir = await getApplicationDocumentsDirectory();
      final f = File(p.join(dir.path, current.substring(5)));
      if (await f.exists()) await f.delete();
    } catch (_) {}
  }

  Future<void> _pullCollection(
    String uid,
    String collection,
    Future<void> Function(Map<String, dynamic>) apply,
  ) async {
    final snap =
        await _firestore.collection('users').doc(uid).collection(collection).get();
    for (final doc in snap.docs) {
      await apply(doc.data());
    }
  }

  Future<void> _upsertGaji(Map<String, dynamic> d) async {
    final id = d['id'] as String;
    final remote = _ms(d['updatedAt']);
    final local = await (_db.select(_db.gajiTable)
          ..where((t) => t.id.equals(id))
          ..limit(1))
        .getSingleOrNull();
    if (!shouldApplyRemote(local?.updatedAt, remote)) return;
    await _db.into(_db.gajiTable).insertOnConflictUpdate(GajiTableCompanion(
          id: Value(id),
          jumlah: Value((d['jumlah'] as num).toDouble()),
          jumlahBebas: Value(
              d['jumlahBebas'] == null ? null : (d['jumlahBebas'] as num).toDouble()),
          tanggal: Value(_ms(d['tanggal'])),
          catatan: Value(d['catatan'] as String?),
          updatedAt: Value(remote),
          isSynced: const Value(true),
          isDeleted: Value(d['isDeleted'] as bool? ?? false),
        ));
  }

  Future<void> _upsertPengeluaran(Map<String, dynamic> d) async {
    final id = d['id'] as String;
    final remote = _ms(d['updatedAt']);
    final local = await (_db.select(_db.pengeluaranTable)
          ..where((t) => t.id.equals(id))
          ..limit(1))
        .getSingleOrNull();
    if (!shouldApplyRemote(local?.updatedAt, remote)) return;
    await _db
        .into(_db.pengeluaranTable)
        .insertOnConflictUpdate(PengeluaranTableCompanion(
          id: Value(id),
          jumlah: Value((d['jumlah'] as num).toDouble()),
          kategoriId: Value(d['kategoriId'] as String),
          tanggal: Value(_ms(d['tanggal'])),
          catatan: Value(d['catatan'] as String?),
          utangId: Value(d['utangId'] as String?),
          updatedAt: Value(remote),
          isSynced: const Value(true),
          isDeleted: Value(d['isDeleted'] as bool? ?? false),
        ));
  }

  Future<void> _upsertUtang(Map<String, dynamic> d) async {
    final id = d['id'] as String;
    final remote = _ms(d['updatedAt']);
    final local = await (_db.select(_db.utangTable)
          ..where((t) => t.id.equals(id))
          ..limit(1))
        .getSingleOrNull();
    if (!shouldApplyRemote(local?.updatedAt, remote)) return;
    await _db.into(_db.utangTable).insertOnConflictUpdate(UtangTableCompanion(
          id: Value(id),
          namaUtang: Value(d['namaUtang'] as String),
          jumlahTotal: Value((d['jumlahTotal'] as num).toDouble()),
          jumlahTerbayar: Value((d['jumlahTerbayar'] as num).toDouble()),
          status: Value(d['status'] as String),
          jatuhTempo:
              Value(d['jatuhTempo'] == null ? null : _ms(d['jatuhTempo'])),
          catatan: Value(d['catatan'] as String?),
          jenis: Value(d['jenis'] as String? ?? 'bulat'),
          tenor: Value(d['tenor'] as int?),
          bungaPersen: Value((d['bungaPersen'] as num?)?.toDouble()),
          tanggalMulai: Value(
              d['tanggalMulai'] == null ? null : _ms(d['tanggalMulai'])),
          updatedAt: Value(remote),
          isSynced: const Value(true),
          isDeleted: Value(d['isDeleted'] as bool? ?? false),
        ));
  }

  Future<void> _upsertRecurring(Map<String, dynamic> d) async {
    final id = d['id'] as String;
    final remote = _ms(d['updatedAt']);
    final local = await (_db.select(_db.recurringTable)
          ..where((t) => t.id.equals(id))
          ..limit(1))
        .getSingleOrNull();
    if (!shouldApplyRemote(local?.updatedAt, remote)) return;
    await _db.into(_db.recurringTable).insertOnConflictUpdate(
          RecurringTableCompanion(
            id: Value(id),
            tipe: Value(d['tipe'] as String),
            nominal: Value((d['nominal'] as num).toDouble()),
            nominalBebas: Value((d['nominalBebas'] as num?)?.toDouble()),
            frekuensi: Value(d['frekuensi'] as String),
            tanggalMulai: Value(_ms(d['tanggalMulai'])),
            tanggalAkhir: Value(
                d['tanggalAkhir'] == null ? null : _ms(d['tanggalAkhir'])),
            terakhirDibuat: Value(
                d['terakhirDibuat'] == null ? null : _ms(d['terakhirDibuat'])),
            sumber: Value(d['sumber'] as String?),
            kategoriId: Value(d['kategoriId'] as String?),
            catatan: Value(d['catatan'] as String?),
            aktif: Value(d['aktif'] as bool? ?? true),
            updatedAt: Value(remote),
            isSynced: const Value(true),
            isDeleted: Value(d['isDeleted'] as bool? ?? false),
          ),
        );
  }

  Future<void> _upsertKategori(Map<String, dynamic> d) async {
    final id = d['id'] as String;
    final remote = _ms(d['updatedAt']);
    final local = await (_db.select(_db.kategoriTable)
          ..where((t) => t.id.equals(id))
          ..limit(1))
        .getSingleOrNull();
    if (!shouldApplyRemote(local?.updatedAt, remote)) return;
    await _db.into(_db.kategoriTable).insertOnConflictUpdate(KategoriTableCompanion(
          id: Value(id),
          nama: Value(d['nama'] as String),
          tipe: Value(d['tipe'] as String),
          updatedAt: Value(remote),
          isSynced: const Value(true),
          isDeleted: Value(d['isDeleted'] as bool? ?? false),
        ));
  }

  // ---- serialisasi ----

  DateTime _ms(dynamic v) =>
      DateTime.fromMillisecondsSinceEpoch((v as num).toInt());

  Map<String, dynamic> _gajiToMap(GajiTableData r) => {
        'id': r.id,
        'jumlah': r.jumlah,
        'jumlahBebas': r.jumlahBebas,
        'tanggal': r.tanggal.millisecondsSinceEpoch,
        'catatan': r.catatan,
        'updatedAt': r.updatedAt.millisecondsSinceEpoch,
        'isDeleted': r.isDeleted,
      };

  Map<String, dynamic> _pengeluaranToMap(PengeluaranTableData r) => {
        'id': r.id,
        'jumlah': r.jumlah,
        'kategoriId': r.kategoriId,
        'tanggal': r.tanggal.millisecondsSinceEpoch,
        'catatan': r.catatan,
        'utangId': r.utangId,
        'updatedAt': r.updatedAt.millisecondsSinceEpoch,
        'isDeleted': r.isDeleted,
      };

  Map<String, dynamic> _utangToMap(UtangTableData r) => {
        'id': r.id,
        'namaUtang': r.namaUtang,
        'jumlahTotal': r.jumlahTotal,
        'jumlahTerbayar': r.jumlahTerbayar,
        'status': r.status,
        'jatuhTempo': r.jatuhTempo?.millisecondsSinceEpoch,
        'catatan': r.catatan,
        'jenis': r.jenis,
        'tenor': r.tenor,
        'bungaPersen': r.bungaPersen,
        'tanggalMulai': r.tanggalMulai?.millisecondsSinceEpoch,
        'updatedAt': r.updatedAt.millisecondsSinceEpoch,
        'isDeleted': r.isDeleted,
      };

  Map<String, dynamic> _recurringToMap(RecurringTableData r) => {
        'id': r.id,
        'tipe': r.tipe,
        'nominal': r.nominal,
        'nominalBebas': r.nominalBebas,
        'frekuensi': r.frekuensi,
        'tanggalMulai': r.tanggalMulai.millisecondsSinceEpoch,
        'tanggalAkhir': r.tanggalAkhir?.millisecondsSinceEpoch,
        'terakhirDibuat': r.terakhirDibuat?.millisecondsSinceEpoch,
        'sumber': r.sumber,
        'kategoriId': r.kategoriId,
        'catatan': r.catatan,
        'aktif': r.aktif,
        'updatedAt': r.updatedAt.millisecondsSinceEpoch,
        'isDeleted': r.isDeleted,
      };

  Map<String, dynamic> _kategoriToMap(KategoriTableData r) => {
        'id': r.id,
        'nama': r.nama,
        'tipe': r.tipe,
        'updatedAt': r.updatedAt.millisecondsSinceEpoch,
        'isDeleted': r.isDeleted,
      };

  // ---- meta & clear ----

  Future<String?> _getMeta(String key) async {
    final r = await (_db.select(_db.syncMetaTable)
          ..where((t) => t.key.equals(key))
          ..limit(1))
        .getSingleOrNull();
    return r?.value;
  }

  Future<void> _setMeta(String key, String value) =>
      _db.into(_db.syncMetaTable).insertOnConflictUpdate(
          SyncMetaTableCompanion(key: Value(key), value: Value(value)));

  // ponytail: clear kategori juga menghapus seed default; akun baru tanpa
  // kategori cloud perlu restart app agar seed jalan lagi. Cukup untuk kasus
  // ganti-akun yang jarang; upgrade kalau jadi masalah.
  Future<void> _clearLocal() async {
    await _db.delete(_db.gajiTable).go();
    await _db.delete(_db.pengeluaranTable).go();
    await _db.delete(_db.utangTable).go();
    await _db.delete(_db.kategoriTable).go();
    // Avatar milik akun lama: hapus file + meta agar tak nyangkut ke akun baru.
    await _deleteLocalAvatarFile();
    await (_db.delete(_db.syncMetaTable)
          ..where((t) => t.key.isIn(
              const ['avatar', 'avatarUpdatedAt', 'avatarSynced'])))
        .go();
  }
}

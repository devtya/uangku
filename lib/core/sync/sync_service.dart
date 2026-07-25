import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart';
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
  }

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
          updatedAt: Value(remote),
          isSynced: const Value(true),
          isDeleted: Value(d['isDeleted'] as bool? ?? false),
        ));
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
  }
}

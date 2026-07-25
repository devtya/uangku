import 'package:drift/drift.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import 'package:uangku/core/constants/app_constants.dart';
import 'package:uangku/core/database/app_database.dart';
import 'package:uangku/features/utang/domain/entities/utang_entity.dart';

/// Notifikasi lokal pengingat jatuh tempo utang (H-1 & hari-H, jam 08:00).
class NotificationService {
  final AppDatabase _db;
  final FlutterLocalNotificationsPlugin _plugin;
  static const _metaKey = 'utangNotif';
  final _rp = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

  bool _enabled = false;
  bool _ready = false;

  NotificationService(this._db, this._plugin);

  bool get enabled => _enabled;

  Future<void> init() async {
    tzdata.initializeTimeZones();
    try {
      final info = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(info.identifier));
    } catch (_) {
      tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));
    }
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );
    _enabled = (await _getMeta(_metaKey)) == 'on';
    _ready = true;
  }

  Future<bool> requestPermission() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    return await android?.requestNotificationsPermission() ?? true;
  }

  Future<void> setEnabled(bool value, List<UtangEntity> utang) async {
    _enabled = value;
    await _setMeta(_metaKey, value ? 'on' : 'off');
    if (value) await requestPermission();
    await rescheduleUtang(utang);
  }

  /// Batalkan semua lalu jadwalkan ulang untuk utang belum lunas ber-jatuh tempo.
  Future<void> rescheduleUtang(List<UtangEntity> utang) async {
    if (!_ready) return;
    await _plugin.cancelAll();
    if (!_enabled) return;

    final now = tz.TZDateTime.now(tz.local);
    var id = 1000;
    for (final u in utang) {
      if (u.status == UtangStatus.lunas) continue;
      final due = u.jatuhTempoBerikutnya;
      if (due == null) continue;
      for (final lead in const [1, 0]) {
        final when =
            tz.TZDateTime(tz.local, due.year, due.month, due.day - lead, 8);
        if (!when.isAfter(now)) continue;
        final kapan = lead == 1 ? 'besok' : 'hari ini';
        await _schedule(
          id++,
          'Jatuh tempo utang',
          '${u.namaUtang} jatuh tempo $kapan · sisa ${_rp.format(u.sisaUtang)}',
          when,
        );
      }
    }
  }

  Future<void> _schedule(
      int id, String title, String body, tz.TZDateTime when) async {
    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: when,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'utang_jatuh_tempo',
          'Jatuh Tempo Utang',
          channelDescription: 'Pengingat jatuh tempo utang',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

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
}

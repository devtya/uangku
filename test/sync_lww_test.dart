import 'package:flutter_test/flutter_test.dart';
import 'package:uangku/core/sync/sync_service.dart';

void main() {
  final t0 = DateTime(2026, 7, 1);
  final t1 = DateTime(2026, 7, 2);

  test('remote lebih baru → diterapkan', () {
    expect(shouldApplyRemote(t0, t1), isTrue);
  });

  test('remote lebih lama → ditolak', () {
    expect(shouldApplyRemote(t1, t0), isFalse);
  });

  test('waktu sama → ditolak (lokal menang, hindari flip-flop)', () {
    expect(shouldApplyRemote(t0, t0), isFalse);
  });

  test('belum ada lokal → selalu diterapkan', () {
    expect(shouldApplyRemote(null, t0), isTrue);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:uangku/shared/utils/month_group.dart';

void main() {
  test('groupByMonth: kelompok per bulan, subtotal & urutan terbaru dulu', () {
    final items = [
      (DateTime(2026, 6, 10), 100.0),
      (DateTime(2026, 7, 5), 200.0),
      (DateTime(2026, 6, 20), 50.0),
      (DateTime(2026, 5, 1), 30.0),
    ];

    final groups =
        groupByMonth(items, (e) => e.$1, (e) => e.$2);

    // 3 bulan, urut terbaru dulu.
    expect(groups.map((g) => g.month).toList(),
        [DateTime(2026, 7), DateTime(2026, 6), DateTime(2026, 5)]);
    // Subtotal Juni = 150.
    expect(groups[1].total, 150.0);
    // Item dalam bulan urut terbaru dulu (20 sebelum 10).
    expect(groups[1].items.first.$1, DateTime(2026, 6, 20));
  });

  test('groupByMonth: list kosong → kosong', () {
    expect(groupByMonth<int>([], (_) => DateTime.now(), (_) => 0).isEmpty, true);
  });
}

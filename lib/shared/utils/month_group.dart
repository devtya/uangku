/// Satu bulan hasil pengelompokan: bulan (hari-1), item-itemnya, dan subtotal.
class MonthGroup<T> {
  final DateTime month;
  final List<T> items;
  final double total;

  const MonthGroup(this.month, this.items, this.total);
}

/// Kelompokkan [items] per bulan, urut terbaru dulu. Item di tiap bulan
/// juga diurutkan terbaru dulu. Dipakai halaman pengeluaran & pendapatan.
List<MonthGroup<T>> groupByMonth<T>(
  List<T> items,
  DateTime Function(T) dateOf,
  double Function(T) amountOf,
) {
  final map = <DateTime, List<T>>{};
  for (final it in items) {
    final d = dateOf(it);
    (map[DateTime(d.year, d.month)] ??= []).add(it);
  }
  final groups = map.entries.map((e) {
    e.value.sort((a, b) => dateOf(b).compareTo(dateOf(a)));
    final total = e.value.fold<double>(0, (s, it) => s + amountOf(it));
    return MonthGroup(e.key, e.value, total);
  }).toList()
    ..sort((a, b) => b.month.compareTo(a.month));
  return groups;
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uangku/core/theme/app_theme.dart';

/// Kartu ringkasan dengan navigasi bulan ‹ Bulan Tahun ›.
class MonthSelectorCard extends StatelessWidget {
  final DateTime month;
  final String label;
  final String total;
  final bool canPrev;
  final bool canNext;

  /// Dipanggil dengan delta -1 (mundur) atau +1 (maju).
  final ValueChanged<int> onChange;

  const MonthSelectorCard({
    super.key,
    required this.month,
    required this.label,
    required this.total,
    required this.canPrev,
    required this.canNext,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(6, 14, 6, 18),
      decoration: BoxDecoration(
        color: context.colors.primary,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _navButton(Icons.chevron_left_rounded,
                  canPrev ? () => onChange(-1) : null),
              Expanded(
                child: Text(
                  DateFormat('MMMM yyyy', 'id_ID').format(month),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              _navButton(Icons.chevron_right_rounded,
                  canNext ? () => onChange(1) : null),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Total $label',
            style: const TextStyle(fontSize: 11, color: Colors.white70),
          ),
          const SizedBox(height: 2),
          Text(
            total,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _navButton(IconData icon, VoidCallback? onTap) => IconButton(
        onPressed: onTap,
        icon: Icon(icon),
        color: Colors.white,
        disabledColor: Colors.white24,
        splashRadius: 20,
      );
}

/// Header pemisah bulan di daftar riwayat: "Juni 2026 · Rp 2.500.000".
class MonthHeader extends StatelessWidget {
  final DateTime month;
  final String total;
  final bool selected;
  final VoidCallback onTap;

  const MonthHeader({
    super.key,
    required this.month,
    required this.total,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        child: Row(
          children: [
            if (selected)
              Container(
                width: 3,
                height: 16,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: context.colors.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            Text(
              DateFormat('MMMM yyyy', 'id_ID').format(month),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: selected
                    ? context.colors.primary
                    : context.colors.textPrimary,
              ),
            ),
            const Spacer(),
            Text(
              total,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: context.colors.textSecondary,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

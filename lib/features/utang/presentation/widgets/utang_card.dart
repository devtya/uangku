import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uangku/core/constants/app_constants.dart';
import 'package:uangku/core/theme/app_theme.dart';
import 'package:uangku/features/utang/domain/entities/utang_entity.dart';

class UtangCard extends StatelessWidget {
  final UtangEntity utang;
  final VoidCallback onTap;

  const UtangCard({
    super.key,
    required this.utang,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final rp = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    final lunas = utang.status == UtangStatus.lunas;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: context.colors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: context.colors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    utang.namaUtang,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: context.colors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _statusBadge(context, lunas),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: utang.progressPercent,
                minHeight: 8,
                backgroundColor: context.colors.divider,
                valueColor: AlwaysStoppedAnimation(
                  lunas ? Colors.green.shade600 : context.colors.primary,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${rp.format(utang.jumlahTerbayar)} / ${rp.format(utang.jumlahTotal)}',
                    style: TextStyle(
                      fontSize: 11,
                      color: context.colors.textSecondary,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
                if (!lunas)
                  Text(
                    'Sisa ${rp.format(utang.sisaUtang)}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: context.colors.textPrimary,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
              ],
            ),
            if (utang.jatuhTempoBerikutnya != null) ...[
              const SizedBox(height: 6),
              _jatuhTempoRow(context, lunas),
            ],
          ],
        ),
      ),
    );
  }

  Widget _statusBadge(BuildContext context, bool lunas) {
    final color = lunas ? Colors.green.shade700 : context.colors.accent;
    final bg = lunas ? Colors.green.shade50 : context.colors.tint;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        lunas ? 'Lunas' : 'Belum lunas',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  Widget _jatuhTempoRow(BuildContext context, bool lunas) {
    final due = utang.jatuhTempoBerikutnya!;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueDay = DateTime(due.year, due.month, due.day);
    final selisihHari = dueDay.difference(today).inDays;

    Color color = context.colors.textSecondary;
    String? tanda;
    if (!lunas) {
      if (selisihHari < 0) {
        color = Colors.red.shade600;
        tanda = 'terlambat';
      } else if (selisihHari <= 7) {
        color = Colors.orange.shade800;
        tanda = 'segera';
      }
    }

    final text = DateFormat('d MMM yyyy', 'id_ID').format(due);
    return Row(
      children: [
        Icon(Icons.event_outlined, size: 13, color: color),
        const SizedBox(width: 4),
        Text(
          'Jatuh tempo $text${tanda != null ? ' ($tanda)' : ''}',
          style: TextStyle(
            fontSize: 11,
            color: color,
            fontWeight: tanda != null ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

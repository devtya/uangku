import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uangku/core/theme/app_theme.dart';
import 'package:uangku/features/gaji/domain/entities/gaji_entity.dart';

class GajiCard extends StatelessWidget {
  final GajiEntity gaji;
  final VoidCallback onTap;

  const GajiCard({
    super.key,
    required this.gaji,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    final dateFormat = DateFormat('d MMMM yyyy', 'id_ID');
    final monthName = DateFormat('MMMM yyyy', 'id_ID').format(gaji.tanggal);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: context.colors.divider),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: context.colors.tint,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                'Rp',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: context.colors.primary,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (gaji.catatan?.isNotEmpty ?? false)
                        ? gaji.catatan!
                        : 'Pendapatan $monthName',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: context.colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Diterima ${dateFormat.format(gaji.tanggal)}',
                    style: TextStyle(
                      fontSize: 11,
                      color: context.colors.textSecondary,
                    ),
                  ),
                  if (gaji.jumlahTersimpan > 0) ...[
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.lock_outline,
                            size: 11, color: context.colors.textMuted),
                        const SizedBox(width: 3),
                        Text(
                          'Ditabung ${currencyFormat.format(gaji.jumlahTersimpan)}',
                          style: TextStyle(
                            fontSize: 11,
                            color: context.colors.textMuted,
                            fontFeatures: [FontFeature.tabularFigures()],
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '+${currencyFormat.format(gaji.jumlah)}',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: context.colors.primary,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

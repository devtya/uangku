import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uangku/core/theme/app_theme.dart';
import 'package:uangku/features/pengeluaran/domain/entities/pengeluaran_entity.dart';

class PengeluaranCard extends StatelessWidget {
  final PengeluaranEntity pengeluaran;
  final String kategoriNama;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const PengeluaranCard({
    super.key,
    required this.pengeluaran,
    required this.kategoriNama,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    final dateFormat = DateFormat('d MMM yyyy', 'id_ID');
    final subtitle = pengeluaran.catatan?.isNotEmpty == true
        ? pengeluaran.catatan!
        : dateFormat.format(pengeluaran.tanggal);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.divider)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: AppColors.tint,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                kategoriNama.isNotEmpty ? kategoriNama[0].toUpperCase() : '?',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    kategoriNama,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '-${currencyFormat.format(pengeluaran.jumlah)}',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
            const SizedBox(width: 4),
            InkWell(
              onTap: onDelete,
              borderRadius: BorderRadius.circular(8),
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(Icons.delete_outline, size: 18, color: AppColors.textMuted),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

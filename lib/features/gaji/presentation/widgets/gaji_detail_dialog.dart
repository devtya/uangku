import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uangku/core/theme/app_theme.dart';
import 'package:uangku/features/gaji/domain/entities/gaji_entity.dart';

enum GajiDetailAction { edit, hapus }

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: TextStyle(fontSize: 12, color: context.colors.textSecondary),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: context.colors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<GajiDetailAction?> showGajiDetailDialog(
  BuildContext context, {
  required GajiEntity gaji,
}) {
  final rp = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
  final dateFormat = DateFormat('d MMMM yyyy', 'id_ID');

  return showDialog<GajiDetailAction>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Detail Gaji'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _DetailRow('Total', rp.format(gaji.jumlah)),
          _DetailRow('Bebas dipakai', rp.format(gaji.jumlahBebas)),
          _DetailRow('Tersimpan', rp.format(gaji.jumlahTersimpan)),
          _DetailRow('Tanggal', dateFormat.format(gaji.tanggal)),
          if (gaji.catatan != null && gaji.catatan!.isNotEmpty)
            _DetailRow('Catatan', gaji.catatan!),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(GajiDetailAction.hapus),
          child: const Text('Hapus'),
        ),
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('Tutup'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(ctx).pop(GajiDetailAction.edit),
          child: const Text('Edit'),
        ),
      ],
    ),
  );
}

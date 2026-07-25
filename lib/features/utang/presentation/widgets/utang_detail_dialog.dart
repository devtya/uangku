import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uangku/core/constants/app_constants.dart';
import 'package:uangku/core/di/injection.dart';
import 'package:uangku/core/theme/app_theme.dart';
import 'package:uangku/features/pengeluaran/domain/entities/pengeluaran_entity.dart';
import 'package:uangku/features/utang/domain/entities/utang_entity.dart';
import 'package:uangku/features/utang/domain/usecases/watch_cicilan_by_utang.dart';

enum UtangDetailAction { edit, hapus, bayar }

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 92,
            child: Text(label,
                style: TextStyle(fontSize: 12, color: context.colors.textSecondary)),
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

Future<UtangDetailAction?> showUtangDetailDialog(
  BuildContext context, {
  required UtangEntity utang,
}) {
  final rp = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
  final dateFormat = DateFormat('d MMMM yyyy', 'id_ID');
  final lunas = utang.status == UtangStatus.lunas;

  return showDialog<UtangDetailAction>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(utang.namaUtang),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _DetailRow('Status', lunas ? 'Lunas' : 'Belum lunas'),
              _DetailRow('Total', rp.format(utang.jumlahTotal)),
              _DetailRow('Terbayar', rp.format(utang.jumlahTerbayar)),
              _DetailRow('Sisa', rp.format(utang.sisaUtang)),
              if (utang.jatuhTempo != null)
                _DetailRow('Jatuh tempo', dateFormat.format(utang.jatuhTempo!)),
              if (utang.catatan != null && utang.catatan!.isNotEmpty)
                _DetailRow('Catatan', utang.catatan!),
              const SizedBox(height: 6),
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
              if (utang.isCicilan) ...[
                const SizedBox(height: 12),
                _DetailRow('Tenor', '${utang.tenor} bulan'),
                _DetailRow('Bunga', '${_fmtNum(utang.bungaPersen!)}% /bln'),
                _DetailRow('Cicilan/bulan', rp.format(utang.cicilanPerBulan)),
                const SizedBox(height: 12),
                Text('Jadwal Cicilan',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: context.colors.textPrimary)),
                const SizedBox(height: 6),
                ...utang.jadwalCicilan.map((c) => _JadwalRow(cicilan: c, rp: rp)),
              ],
              const SizedBox(height: 16),
              Text(
                'Riwayat Pembayaran',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: context.colors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              _RiwayatCicilan(utangId: utang.id, rp: rp),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(UtangDetailAction.hapus),
          child: const Text('Hapus'),
        ),
        if (!lunas)
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(UtangDetailAction.bayar),
            child: const Text('Bayar cicilan'),
          ),
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('Tutup'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(ctx).pop(UtangDetailAction.edit),
          child: const Text('Edit'),
        ),
      ],
    ),
  );
}

String _fmtNum(double v) =>
    v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toString();

class _JadwalRow extends StatelessWidget {
  final CicilanJadwal cicilan;
  final NumberFormat rp;
  const _JadwalRow({required this.cicilan, required this.rp});

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('d MMM yyyy', 'id_ID');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(cicilan.lunas ? Icons.check_circle : Icons.circle_outlined,
              size: 16,
              color: cicilan.lunas
                  ? Colors.green.shade600
                  : context.colors.textMuted),
          const SizedBox(width: 8),
          Expanded(
            child: Text('Cicilan ${cicilan.nomor} · ${df.format(cicilan.jatuhTempo)}',
                style: TextStyle(fontSize: 12, color: context.colors.textSecondary)),
          ),
          Text(rp.format(cicilan.nominal),
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: context.colors.textPrimary,
                  fontFeatures: const [FontFeature.tabularFigures()])),
        ],
      ),
    );
  }
}

class _RiwayatCicilan extends StatelessWidget {
  final String utangId;
  final NumberFormat rp;
  const _RiwayatCicilan({required this.utangId, required this.rp});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('d MMM yyyy', 'id_ID');
    return StreamBuilder<List<PengeluaranEntity>>(
      stream: sl<WatchCicilanByUtang>()(utangId),
      builder: (context, snapshot) {
        final list = snapshot.data ?? const <PengeluaranEntity>[];
        if (list.isEmpty) {
          return Text(
            'Belum ada pembayaran',
            style: TextStyle(fontSize: 12, color: context.colors.textSecondary),
          );
        }
        return Column(
          children: list
              .map(
                (p) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Icon(Icons.payments_outlined,
                          size: 14, color: context.colors.textMuted),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          dateFormat.format(p.tanggal),
                          style: TextStyle(
                              fontSize: 12, color: context.colors.textSecondary),
                        ),
                      ),
                      Text(
                        rp.format(p.jumlah),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: context.colors.textPrimary,
                          fontFeatures: [FontFeature.tabularFigures()],
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uangku/core/constants/app_constants.dart';
import 'package:uangku/core/di/injection.dart';
import 'package:uangku/core/theme/app_theme.dart';
import 'package:uangku/features/pengeluaran/domain/entities/kategori_entity.dart';
import 'package:uangku/features/pengeluaran/domain/usecases/watch_kategori_pengeluaran.dart';
import 'package:uangku/features/recurring/domain/entities/recurring_entity.dart';
import 'package:uangku/features/recurring/domain/usecases/add_recurring.dart';
import 'package:uangku/features/recurring/domain/usecases/delete_recurring.dart';
import 'package:uangku/features/recurring/domain/usecases/generate_due_recurring.dart';
import 'package:uangku/features/recurring/domain/usecases/update_recurring.dart';
import 'package:uangku/features/recurring/domain/usecases/watch_recurring.dart';
import 'package:uangku/features/recurring/presentation/widgets/recurring_form_dialog.dart';

class RecurringPage extends StatelessWidget {
  const RecurringPage({super.key});

  static const _freqLabel = {
    RecurringFrekuensi.harian: 'Harian',
    RecurringFrekuensi.mingguan: 'Mingguan',
    RecurringFrekuensi.bulanan: 'Bulanan',
  };

  @override
  Widget build(BuildContext context) {
    final rp =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(title: const Text('Transaksi Berulang')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _tambah(context),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<KategoriEntity>>(
        stream: sl<WatchKategoriPengeluaran>()(),
        builder: (context, katSnap) {
          final namaKat = {
            for (final k in katSnap.data ?? const <KategoriEntity>[])
              k.id: k.nama
          };
          return StreamBuilder<List<RecurringEntity>>(
            stream: sl<WatchRecurring>()(),
            builder: (context, snap) {
              final list = snap.data ?? const <RecurringEntity>[];
              if (list.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Text(
                      'Belum ada transaksi berulang.\nMis. uang kopi harian, langganan bulanan.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 100),
                itemCount: list.length,
                separatorBuilder: (_, __) => const SizedBox(height: 4),
                itemBuilder: (_, i) {
                  final r = list[i];
                  final income = r.isPendapatan;
                  final judul = income
                      ? (r.sumber?.isNotEmpty == true ? r.sumber! : 'Pendapatan')
                      : (namaKat[r.kategoriId] ?? 'Pengeluaran');
                  return ListTile(
                    onTap: () => _edit(context, r),
                    leading: Icon(
                      income
                          ? Icons.south_west_rounded
                          : Icons.north_east_rounded,
                      color: income ? Colors.green.shade600 : context.colors.textMuted,
                    ),
                    title: Text(judul,
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    subtitle: Text(
                        '${rp.format(r.nominal)} · ${_freqLabel[r.frekuensi] ?? r.frekuensi}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Switch(
                          value: r.aktif,
                          onChanged: (v) =>
                              sl<UpdateRecurring>()(r.copyWith(aktif: v)),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, size: 20),
                          onPressed: () => _hapus(context, r),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _tambah(BuildContext context) async {
    final r = await showRecurringFormDialog(context);
    if (r != null) {
      await sl<AddRecurring>()(r);
      await sl<GenerateDueRecurring>()(); // langsung buat yang terlewat
    }
  }

  Future<void> _edit(BuildContext context, RecurringEntity existing) async {
    final r = await showRecurringFormDialog(context, existing: existing);
    if (r != null) {
      await sl<UpdateRecurring>()(r);
      await sl<GenerateDueRecurring>()();
    }
  }

  Future<void> _hapus(BuildContext context, RecurringEntity r) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Aturan'),
        content: const Text(
            'Hapus aturan berulang ini? Entri yang sudah dibuat tidak ikut terhapus.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Batal')),
          FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Hapus')),
        ],
      ),
    );
    if (ok == true) await sl<DeleteRecurring>()(r.id);
  }
}

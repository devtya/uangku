import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uangku/core/di/injection.dart';
import 'package:uangku/core/theme/app_theme.dart';
import 'package:uangku/features/pengeluaran/domain/entities/kategori_entity.dart';
import 'package:uangku/features/pengeluaran/domain/entities/pengeluaran_entity.dart';
import 'package:uangku/features/pengeluaran/domain/usecases/watch_kategori_pengeluaran.dart';
import 'package:uangku/features/pengeluaran/presentation/bloc/pengeluaran_bloc.dart';
import 'package:uangku/features/pengeluaran/presentation/bloc/pengeluaran_event.dart';
import 'package:uangku/features/pengeluaran/presentation/bloc/pengeluaran_state.dart';
import 'package:uangku/features/pengeluaran/presentation/widgets/kelola_kategori_sheet.dart';
import 'package:uangku/features/pengeluaran/presentation/widgets/pengeluaran_card.dart';
import 'package:uangku/features/pengeluaran/presentation/widgets/pengeluaran_form_dialog.dart';

class PengeluaranPage extends StatefulWidget {
  const PengeluaranPage({super.key});

  @override
  State<PengeluaranPage> createState() => _PengeluaranPageState();
}

class _PengeluaranPageState extends State<PengeluaranPage> {
  @override
  void initState() {
    super.initState();
    context.read<PengeluaranBloc>().add(const PengeluaranWatchRequested());
  }

  Future<void> _showAddDialog() async {
    final result = await showPengeluaranFormDialog(context);
    if (result != null && mounted) {
      context.read<PengeluaranBloc>().add(PengeluaranAddRequested(
            jumlah: result.jumlah,
            kategoriId: result.kategoriId,
            tanggal: result.tanggal,
            catatan: result.catatan,
          ));
    }
  }

  Future<void> _showEditDialog(PengeluaranEntity pengeluaran) async {
    final result =
        await showPengeluaranFormDialog(context, existing: pengeluaran);
    if (result != null && mounted) {
      context.read<PengeluaranBloc>().add(PengeluaranUpdateRequested(
            pengeluaran.copyWith(
              jumlah: result.jumlah,
              kategoriId: result.kategoriId,
              tanggal: result.tanggal,
              catatan: result.catatan,
            ),
          ));
    }
  }

  Future<bool> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Pengeluaran'),
        content: const Text('Yakin ingin menghapus data pengeluaran ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final rp = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );

    return SafeArea(
      bottom: false,
      child: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 12, 14),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Pengeluaran',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: context.colors.textPrimary,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.tune_rounded,
                          size: 20, color: context.colors.textMuted),
                      tooltip: 'Kelola kategori',
                      onPressed: () => showKelolaKategoriSheet(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: StreamBuilder<List<KategoriEntity>>(
                  stream: sl<WatchKategoriPengeluaran>()(),
                  builder: (context, katSnapshot) {
                    final namaById = {
                      for (final k in katSnapshot.data ?? const <KategoriEntity>[])
                        k.id: k.nama,
                    };
                    return BlocConsumer<PengeluaranBloc, PengeluaranState>(
                      listener: (context, state) {
                        if (state is PengeluaranError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.message),
                              backgroundColor:
                                  Theme.of(context).colorScheme.error,
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is PengeluaranInitial ||
                            state is PengeluaranLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (state is PengeluaranLoaded) {
                          return _buildContent(state.pengeluaranList, namaById, rp);
                        }
                        return const SizedBox.shrink();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: _showAddDialog,
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    List<PengeluaranEntity> list,
    Map<String, String> namaById,
    NumberFormat rp,
  ) {
    final now = DateTime.now();
    final totalBulanIni = list
        .where((p) => p.tanggal.year == now.year && p.tanggal.month == now.month)
        .fold<double>(0, (sum, p) => sum + p.jumlah);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 18),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: context.colors.primary,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pengeluaran ${DateFormat('MMMM yyyy', 'id_ID').format(now)}',
                style: const TextStyle(fontSize: 11, color: Colors.white70),
              ),
              const SizedBox(height: 4),
              Text(
                rp.format(totalBulanIni),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
        ),
        Text(
          'Riwayat',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: context.colors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        if (list.isEmpty)
          Padding(
            padding: EdgeInsets.only(top: 40),
            child: Center(
              child: Text(
                'Belum ada pengeluaran',
                style: TextStyle(fontSize: 13, color: context.colors.textSecondary),
              ),
            ),
          )
        else
          ...list.map(
            (p) => PengeluaranCard(
              pengeluaran: p,
              kategoriNama: namaById[p.kategoriId] ?? 'Tanpa kategori',
              onTap: () => _showEditDialog(p),
              onDelete: () async {
                final confirmed = await _confirmDelete();
                if (confirmed && mounted) {
                  context
                      .read<PengeluaranBloc>()
                      .add(PengeluaranDeleteRequested(p.id));
                }
              },
            ),
          ),
      ],
    );
  }
}

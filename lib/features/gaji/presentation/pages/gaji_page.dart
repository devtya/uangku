import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uangku/core/theme/app_theme.dart';
import 'package:uangku/features/gaji/domain/entities/gaji_entity.dart';
import 'package:uangku/features/gaji/presentation/bloc/gaji_bloc.dart';
import 'package:uangku/features/gaji/presentation/bloc/gaji_event.dart';
import 'package:uangku/features/gaji/presentation/bloc/gaji_state.dart';
import 'package:uangku/features/gaji/presentation/widgets/gaji_card.dart';
import 'package:uangku/features/gaji/presentation/widgets/gaji_detail_dialog.dart';
import 'package:uangku/features/gaji/presentation/widgets/gaji_form_dialog.dart';

class GajiPage extends StatefulWidget {
  const GajiPage({super.key});

  @override
  State<GajiPage> createState() => _GajiPageState();
}

class _GajiPageState extends State<GajiPage> {
  @override
  void initState() {
    super.initState();
    context.read<GajiBloc>().add(const GajiWatchRequested());
  }

  Future<void> _showAddDialog() async {
    final result = await showGajiFormDialog(context);
    if (result != null && mounted) {
      context.read<GajiBloc>().add(GajiAddRequested(
            jumlah: result.jumlah,
            jumlahBebas: result.jumlahBebas,
            tanggal: result.tanggal,
            catatan: result.catatan,
          ));
    }
  }

  Future<void> _showDetail(GajiEntity gaji) async {
    final action = await showGajiDetailDialog(context, gaji: gaji);
    if (!mounted || action == null) return;
    switch (action) {
      case GajiDetailAction.edit:
        _showEditDialog(gaji);
      case GajiDetailAction.hapus:
        final confirmed = await _confirmDelete(gaji.id);
        if (confirmed && mounted) {
          context.read<GajiBloc>().add(GajiDeleteRequested(gaji.id));
        }
    }
  }

  Future<void> _showEditDialog(GajiEntity gaji) async {
    final result = await showGajiFormDialog(context, existingGaji: gaji);
    if (result != null && mounted) {
      context.read<GajiBloc>().add(GajiUpdateRequested(
            gaji.copyWith(
              jumlah: result.jumlah,
              jumlahBebas: result.jumlahBebas,
              tanggal: result.tanggal,
              catatan: result.catatan,
            ),
          ));
    }
  }

  Future<bool> _confirmDelete(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Gaji'),
        content: const Text('Yakin ingin menghapus data gaji ini?'),
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
                padding: const EdgeInsets.fromLTRB(20, 14, 8, 0),
                child: SizedBox(
                  height: 52,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Gaji',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: context.colors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: BlocListener<GajiBloc, GajiState>(
                  listener: (context, state) {
                    if (state is GajiError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: Theme.of(context).colorScheme.error,
                        ),
                      );
                    }
                  },
                  child: BlocBuilder<GajiBloc, GajiState>(
                    builder: (context, state) {
                      if (state is GajiInitial || state is GajiLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state is GajiLoaded) {
                        final list = state.gajiList;
                        final now = DateTime.now();
                        final tahunIni = list
                            .where((g) => g.tanggal.year == now.year)
                            .fold<double>(0, (sum, g) => sum + g.jumlah);
                        final bulanAktif = list
                            .where((g) => g.tanggal.year == now.year)
                            .map((g) => g.tanggal.month)
                            .toSet()
                            .length;
                        final rataRata =
                            bulanAktif > 0 ? tahunIni / bulanAktif : 0.0;

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
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Total Tahun Ini',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.white70,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          rp.format(tahunIni),
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
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        const Text(
                                          'Rata-rata/Bulan',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.white70,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          rp.format(rataRata),
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
                                    'Belum ada data gaji',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: context.colors.textSecondary,
                                    ),
                                  ),
                                ),
                              )
                            else
                              ...list.map(
                                (gaji) => GajiCard(
                                  gaji: gaji,
                                  onTap: () => _showDetail(gaji),
                                ),
                              ),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
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
}

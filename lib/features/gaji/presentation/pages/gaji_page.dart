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
import 'package:uangku/shared/utils/month_group.dart';
import 'package:uangku/shared/widgets/month_selector.dart';

class GajiPage extends StatefulWidget {
  const GajiPage({super.key});

  @override
  State<GajiPage> createState() => _GajiPageState();
}

class _GajiPageState extends State<GajiPage> {
  late DateTime _selectedMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedMonth = DateTime(now.year, now.month);
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
        title: const Text('Hapus Pendapatan'),
        content: const Text('Yakin ingin menghapus data pendapatan ini?'),
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
                          'Pendapatan',
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
                        final groups = groupByMonth<GajiEntity>(
                            list, (g) => g.tanggal, (g) => g.jumlah);
                        final totalTerpilih = groups
                            .where((g) => g.month == _selectedMonth)
                            .fold<double>(0, (s, g) => s + g.total);

                        final now = DateTime.now();
                        final thisMonth = DateTime(now.year, now.month);
                        final canNext = _selectedMonth.isBefore(thisMonth);
                        final earliest =
                            groups.isNotEmpty ? groups.last.month : thisMonth;
                        final canPrev = _selectedMonth.isAfter(earliest);

                        return ListView(
                          padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                          children: [
                            MonthSelectorCard(
                              month: _selectedMonth,
                              label: 'Pendapatan',
                              total: rp.format(totalTerpilih),
                              canPrev: canPrev,
                              canNext: canNext,
                              onChange: (delta) => setState(() =>
                                  _selectedMonth = DateTime(_selectedMonth.year,
                                      _selectedMonth.month + delta)),
                            ),
                            const SizedBox(height: 18),
                            if (groups.isEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 40),
                                child: Center(
                                  child: Text(
                                    'Belum ada data pendapatan',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: context.colors.textSecondary,
                                    ),
                                  ),
                                ),
                              )
                            else
                              for (final grp in groups) ...[
                                MonthHeader(
                                  month: grp.month,
                                  total: rp.format(grp.total),
                                  selected: grp.month == _selectedMonth,
                                  onTap: () => setState(
                                      () => _selectedMonth = grp.month),
                                ),
                                ...grp.items.map(
                                  (gaji) => GajiCard(
                                    gaji: gaji,
                                    onTap: () => _showDetail(gaji),
                                  ),
                                ),
                              ],
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

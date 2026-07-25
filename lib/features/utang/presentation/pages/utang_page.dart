import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uangku/core/constants/app_constants.dart';
import 'package:uangku/core/theme/app_theme.dart';
import 'package:uangku/features/utang/domain/entities/utang_entity.dart';
import 'package:uangku/features/utang/presentation/bloc/utang_bloc.dart';
import 'package:uangku/features/utang/presentation/bloc/utang_event.dart';
import 'package:uangku/features/utang/presentation/bloc/utang_state.dart';
import 'package:uangku/features/utang/presentation/widgets/bayar_cicilan_dialog.dart';
import 'package:uangku/features/utang/presentation/widgets/utang_card.dart';
import 'package:uangku/features/utang/presentation/widgets/utang_form_dialog.dart';

class UtangPage extends StatefulWidget {
  const UtangPage({super.key});

  @override
  State<UtangPage> createState() => _UtangPageState();
}

class _UtangPageState extends State<UtangPage> {
  @override
  void initState() {
    super.initState();
    context.read<UtangBloc>().add(const UtangWatchRequested());
  }

  Future<void> _showAddDialog() async {
    final result = await showUtangFormDialog(context);
    if (result != null && mounted) {
      context.read<UtangBloc>().add(UtangAddRequested(
            namaUtang: result.namaUtang,
            jumlahTotal: result.jumlahTotal,
            jatuhTempo: result.jatuhTempo,
            catatan: result.catatan,
          ));
    }
  }

  Future<void> _showEditDialog(UtangEntity utang) async {
    final result = await showUtangFormDialog(context, existing: utang);
    if (result != null && mounted) {
      context.read<UtangBloc>().add(UtangUpdateRequested(
            utang.copyWith(
              namaUtang: result.namaUtang,
              jumlahTotal: result.jumlahTotal,
              jatuhTempo: result.jatuhTempo,
              catatan: result.catatan,
            ),
          ));
    }
  }

  Future<void> _showBayarDialog(UtangEntity utang) async {
    final result = await showBayarCicilanDialog(context, utang: utang);
    if (result != null && mounted) {
      context.read<UtangBloc>().add(UtangBayarCicilanRequested(
            utangId: utang.id,
            jumlah: result.jumlah,
            tanggal: result.tanggal,
          ));
    }
  }

  Future<bool> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Utang'),
        content: const Text('Yakin ingin menghapus data utang ini?'),
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
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Utang',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: BlocConsumer<UtangBloc, UtangState>(
                  listener: (context, state) {
                    if (state is UtangError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: Theme.of(context).colorScheme.error,
                        ),
                      );
                    } else if (state is UtangBayarSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Pembayaran cicilan dicatat')),
                      );
                    }
                  },
                  // Abaikan sinyal transien agar list (UtangLoaded) tidak flicker.
                  buildWhen: (_, current) => current is! UtangBayarSuccess,
                  builder: (context, state) {
                    if (state is UtangInitial || state is UtangLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is UtangLoaded) {
                      return _buildContent(state.utangList, rp);
                    }
                    return const SizedBox.shrink();
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

  Widget _buildContent(List<UtangEntity> list, NumberFormat rp) {
    final totalSisa = list
        .where((u) => u.status == UtangStatus.belumLunas)
        .fold<double>(0, (sum, u) => sum + u.sisaUtang);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 18),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Total Sisa Utang',
                style: TextStyle(fontSize: 11, color: Colors.white70),
              ),
              const SizedBox(height: 4),
              Text(
                rp.format(totalSisa),
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
        const Text(
          'Daftar Utang',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        if (list.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 40),
            child: Center(
              child: Text(
                'Belum ada utang',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
            ),
          )
        else
          ...list.map(
            (u) => UtangCard(
              utang: u,
              onTap: () => _showEditDialog(u),
              onBayar: () => _showBayarDialog(u),
              onDelete: () async {
                final confirmed = await _confirmDelete();
                if (confirmed && mounted) {
                  context.read<UtangBloc>().add(UtangDeleteRequested(u.id));
                }
              },
            ),
          ),
      ],
    );
  }
}

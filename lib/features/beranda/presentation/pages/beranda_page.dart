import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uangku/core/theme/app_theme.dart';
import 'package:uangku/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:uangku/features/auth/presentation/bloc/auth_event.dart';

// ponytail: dashboard figures are sample data matching the design spec.
// Wire real aggregation (saldo = gaji - pengeluaran, tren, utang jatuh tempo)
// once the Pengeluaran & Utang feature layers exist — this page stays the view.
final _rp = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

class BerandaPage extends StatelessWidget {
  const BerandaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final today = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(DateTime.now());
    return SafeArea(
      bottom: false,
      child: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Halo, Dita',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary)),
                          const SizedBox(height: 4),
                          Text(today,
                              style: const TextStyle(
                                  fontSize: 12, color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                          color: AppColors.tint, shape: BoxShape.circle),
                      alignment: Alignment.center,
                      child: const Text('D',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary)),
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      icon: Icon(Icons.logout_rounded,
                          size: 18, color: AppColors.textMuted),
                      onPressed: () =>
                          context.read<AuthBloc>().add(const AuthSignOutRequested()),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                  children: const [
                    _BalanceCard(
                      saldo: 8450000,
                      pemasukan: 12000000,
                      pengeluaran: 3550000,
                    ),
                    SizedBox(height: 22),
                    _SectionHeader(title: 'Tren Pengeluaran', trailing: '6 Bulan'),
                    SizedBox(height: 10),
                    _SpendingChart(),
                    SizedBox(height: 22),
                    _SectionHeader(
                      title: 'Utang Jatuh Tempo',
                      trailing: 'Lihat Semua',
                    ),
                    SizedBox(height: 10),
                    _DueDebts(),
                    SizedBox(height: 22),
                    _SectionHeader(
                      title: 'Transaksi Terbaru',
                      trailing: 'Lihat Semua',
                    ),
                    SizedBox(height: 6),
                    _RecentTransactions(),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {}, // ponytail: opens Tambah Transaksi (screen 05) when built
              shape: const CircleBorder(),
              child: const Icon(Icons.add, size: 28),
            ),
          ),
        ],
      ),
    );
  }

}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard(
      {required this.saldo, required this.pemasukan, required this.pengeluaran});

  final int saldo;
  final int pemasukan;
  final int pengeluaran;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('SALDO BULAN INI',
              style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 0.5,
                  color: Colors.white.withValues(alpha: 0.75))),
          const SizedBox(height: 16),
          Text(_rp.format(saldo),
              style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontFeatures: [FontFeature.tabularFigures()])),
          const SizedBox(height: 16),
          Divider(color: Colors.white.withValues(alpha: 0.15), height: 1),
          const SizedBox(height: 16),
          Row(
            children: [
              _stat('Pemasukan', '+${_rp.format(pemasukan)}'),
              const Spacer(),
              _stat('Pengeluaran', '-${_rp.format(pengeluaran)}',
                  end: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stat(String label, String value, {bool end = false}) {
    return Column(
      crossAxisAlignment: end ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 11, color: Colors.white.withValues(alpha: 0.7))),
        const SizedBox(height: 2),
        Text(value,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontFeatures: [FontFeature.tabularFigures()])),
      ],
    );
  }
}

class _SpendingChart extends StatelessWidget {
  const _SpendingChart();

  @override
  Widget build(BuildContext context) {
    // (label, bar height px, isCurrent)
    const bars = [
      ('Feb', 38.0, false),
      ('Mar', 52.0, false),
      ('Apr', 70.0, false),
      ('Mei', 48.0, false),
      ('Jun', 84.0, false),
      ('Jul', 100.0, true),
    ];
    final barWidgets = <Widget>[];
    final labelWidgets = <Widget>[];
    for (final (label, h, current) in bars) {
      barWidgets.add(Container(
        width: 22,
        height: h,
        decoration: BoxDecoration(
          color: current
              ? AppColors.primary
              : AppColors.accent.withValues(alpha: 0.35 + h / 250),
          borderRadius: BorderRadius.circular(6),
        ),
      ));
      labelWidgets.add(Text(label,
          style: TextStyle(
              fontSize: 10,
              fontWeight: current ? FontWeight.w700 : FontWeight.w400,
              color: current
                  ? AppColors.primary
                  : AppColors.textSecondary)));
    }
    return Column(
      children: [
        SizedBox(
          height: 100,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: barWidgets,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: labelWidgets,
        ),
      ],
    );
  }
}

class _DueDebts extends StatelessWidget {
  const _DueDebts();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const [
          _DebtCard(
              nama: 'Cicilan Motor',
              badge: 'H-3',
              jumlah: 1850000,
              progress: 0.65,
              jatuhTempo: '27 Jul 2026'),
          SizedBox(width: 12),
          _DebtCard(
              nama: 'Kartu Kredit',
              badge: 'H-9',
              jumlah: 620000,
              progress: 0.30,
              jatuhTempo: '2 Agu 2026'),
        ],
      ),
    );
  }
}

class _DebtCard extends StatelessWidget {
  const _DebtCard(
      {required this.nama,
      required this.badge,
      required this.jumlah,
      required this.progress,
      required this.jatuhTempo});

  final String nama;
  final String badge;
  final int jumlah;
  final double progress;
  final String jatuhTempo;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(nama,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w700)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                    color: AppColors.tint,
                    borderRadius: BorderRadius.circular(8)),
                child: Text(badge,
                    style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(_rp.format(jumlah),
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFeatures: [FontFeature.tabularFigures()])),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: AppColors.divider,
              valueColor: const AlwaysStoppedAnimation(AppColors.accent),
            ),
          ),
          const SizedBox(height: 10),
          Text('Jatuh tempo $jatuhTempo',
              style: const TextStyle(
                  fontSize: 11, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _RecentTransactions extends StatelessWidget {
  const _RecentTransactions();

  @override
  Widget build(BuildContext context) {
    const items = [
      ('M', 'Makan Siang', 'Makan · 12:30', '-Rp45.000', false),
      ('G', 'Gaji Juli', 'Gaji · 09:00', '+Rp12.000.000', true),
      ('T', 'Transportasi', 'Transport · 08:10', '-Rp20.000', false),
    ];
    return Column(
      children: [
        for (var i = 0; i < items.length; i++)
          _TxnRow(
            glyph: items[i].$1,
            title: items[i].$2,
            subtitle: items[i].$3,
            amount: items[i].$4,
            income: items[i].$5,
            divider: i < items.length - 1,
          ),
      ],
    );
  }
}

class _TxnRow extends StatelessWidget {
  const _TxnRow(
      {required this.glyph,
      required this.title,
      required this.subtitle,
      required this.amount,
      required this.income,
      required this.divider});

  final String glyph;
  final String title;
  final String subtitle;
  final String amount;
  final bool income;
  final bool divider;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: divider
            ? const Border(bottom: BorderSide(color: AppColors.divider))
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.15),
                shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Text(glyph,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Text(amount,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: income ? AppColors.primary : AppColors.textPrimary,
                  fontFeatures: const [FontFeature.tabularFigures()])),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.trailing});

  final String title;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
        if (trailing != null)
          Text(trailing!,
              style:
                  const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      ],
    );
  }
}


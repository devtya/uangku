import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uangku/core/constants/app_constants.dart';
import 'package:uangku/core/di/injection.dart';
import 'package:uangku/core/theme/app_theme.dart';
import 'package:uangku/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:uangku/features/auth/presentation/bloc/auth_state.dart';
import 'package:uangku/features/settings/presentation/pages/settings_page.dart';
import 'package:uangku/features/gaji/domain/entities/gaji_entity.dart';
import 'package:uangku/features/gaji/presentation/bloc/gaji_bloc.dart';
import 'package:uangku/features/gaji/presentation/bloc/gaji_state.dart';
import 'package:uangku/features/pengeluaran/domain/entities/kategori_entity.dart';
import 'package:uangku/features/pengeluaran/domain/entities/pengeluaran_entity.dart';
import 'package:uangku/features/pengeluaran/domain/usecases/watch_kategori_pengeluaran.dart';
import 'package:uangku/features/pengeluaran/presentation/bloc/pengeluaran_bloc.dart';
import 'package:uangku/features/pengeluaran/presentation/bloc/pengeluaran_state.dart';
import 'package:uangku/features/utang/domain/entities/utang_entity.dart';
import 'package:uangku/features/utang/presentation/bloc/utang_bloc.dart';
import 'package:uangku/features/utang/presentation/bloc/utang_state.dart';

final _rp = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

class BerandaPage extends StatelessWidget {
  const BerandaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final today = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(DateTime.now());

    final authState = context.watch<AuthBloc>().state;
    final nama = authState is AuthAuthenticated
        ? (authState.user.displayName?.trim().isNotEmpty == true
            ? authState.user.displayName!.trim()
            : authState.user.email.split('@').first)
        : 'Pengguna';
    final initial = nama.isNotEmpty ? nama[0].toUpperCase() : '?';

    final gajiList = _gaji(context.watch<GajiBloc>().state);
    final pengeluaranList = _peng(context.watch<PengeluaranBloc>().state);
    final utangList = _utang(context.watch<UtangBloc>().state);

    final now = DateTime.now();
    bool sameMonth(DateTime d) => d.year == now.year && d.month == now.month;
    final gajiBulan = gajiList.where((g) => sameMonth(g.tanggal));
    final pemasukan = gajiBulan.fold<double>(0, (s, g) => s + g.jumlah);
    final bebasBulan = gajiBulan.fold<double>(0, (s, g) => s + g.jumlahBebas);
    final ditabungBulan = pemasukan - bebasBulan;
    final pengeluaran = pengeluaranList
        .where((p) => sameMonth(p.tanggal))
        .fold<double>(0, (s, p) => s + p.jumlah);
    // Saldo yang boleh dipakai = porsi bebas - pengeluaran (bukan total gaji).
    final saldo = bebasBulan - pengeluaran;
    // Akumulasi seluruh porsi yang wajib disimpan (tak boleh disentuh).
    final totalTabungan =
        gajiList.fold<double>(0, (s, g) => s + g.jumlahTersimpan);

    final tren = _trenPengeluaran(pengeluaranList, now);

    final dueDebts = utangList
        .where((u) =>
            u.status == UtangStatus.belumLunas && u.jatuhTempoBerikutnya != null)
        .toList()
      ..sort((a, b) =>
          a.jatuhTempoBerikutnya!.compareTo(b.jatuhTempoBerikutnya!));

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 8, 0),
            child: SizedBox(
              height: 52,
              child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Halo, $nama',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: context.colors.textPrimary)),
                      const SizedBox(height: 4),
                      Text(today,
                          style: TextStyle(
                              fontSize: 12, color: context.colors.textSecondary)),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SettingsPage()),
                  ),
                  customBorder: const CircleBorder(),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: context.colors.tint, shape: BoxShape.circle),
                    alignment: Alignment.center,
                    child: Text(initial,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: context.colors.primary)),
                  ),
                ),
              ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
              children: [
                _BalanceCard(
                  saldo: saldo,
                  pemasukan: pemasukan,
                  ditabung: ditabungBulan,
                  pengeluaran: pengeluaran,
                  totalTabungan: totalTabungan,
                ),
                const SizedBox(height: 22),
                const _SectionHeader(title: 'Tren Pengeluaran', trailing: '6 Bulan'),
                const SizedBox(height: 10),
                _SpendingChart(data: tren),
                const SizedBox(height: 22),
                const _SectionHeader(title: 'Utang Jatuh Tempo'),
                const SizedBox(height: 10),
                _DueDebts(utang: dueDebts, now: now),
                const SizedBox(height: 22),
                const _SectionHeader(title: 'Transaksi Terbaru'),
                const SizedBox(height: 6),
                _RecentTransactions(gaji: gajiList, pengeluaran: pengeluaranList),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static List<GajiEntity> _gaji(GajiState s) =>
      s is GajiLoaded ? s.gajiList : const [];
  static List<PengeluaranEntity> _peng(PengeluaranState s) =>
      s is PengeluaranLoaded ? s.pengeluaranList : const [];
  static List<UtangEntity> _utang(UtangState s) =>
      s is UtangLoaded ? s.utangList : const [];

  /// Total pengeluaran per bulan untuk 6 bulan terakhir (termasuk bulan ini).
  static List<_BulanTotal> _trenPengeluaran(
      List<PengeluaranEntity> list, DateTime now) {
    final result = <_BulanTotal>[];
    for (var i = 5; i >= 0; i--) {
      final m = DateTime(now.year, now.month - i);
      final total = list
          .where((p) => p.tanggal.year == m.year && p.tanggal.month == m.month)
          .fold<double>(0, (s, p) => s + p.jumlah);
      result.add(_BulanTotal(DateFormat('MMM', 'id_ID').format(m), total));
    }
    return result;
  }
}

class _BulanTotal {
  final String label;
  final double total;
  const _BulanTotal(this.label, this.total);
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({
    required this.saldo,
    required this.pemasukan,
    required this.ditabung,
    required this.pengeluaran,
    required this.totalTabungan,
  });

  final double saldo;
  final double pemasukan;
  final double ditabung;
  final double pengeluaran;
  final double totalTabungan;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: context.colors.primary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('SALDO BISA DIPAKAI',
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
              _stat('Ditabung', _rp.format(ditabung),
                  align: CrossAxisAlignment.center),
              _stat('Pengeluaran', '-${_rp.format(pengeluaran)}',
                  align: CrossAxisAlignment.end),
            ],
          ),
          if (totalTabungan > 0) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.lock_outline, size: 15, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text('Total Tabungan Terkunci',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.85))),
                  ),
                  Text(_rp.format(totalTabungan),
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontFeatures: [FontFeature.tabularFigures()])),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _stat(String label, String value,
      {CrossAxisAlignment align = CrossAxisAlignment.start}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: align,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 11, color: Colors.white.withValues(alpha: 0.7))),
          const SizedBox(height: 2),
          Text(value,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontFeatures: [FontFeature.tabularFigures()])),
        ],
      ),
    );
  }
}

class _SpendingChart extends StatelessWidget {
  const _SpendingChart({required this.data});

  final List<_BulanTotal> data;

  @override
  Widget build(BuildContext context) {
    final maxTotal = data.fold<double>(0, (m, e) => e.total > m ? e.total : m);
    if (maxTotal == 0) {
      return SizedBox(
        height: 120,
        child: Center(
          child: Text('Belum ada data pengeluaran',
              style: TextStyle(fontSize: 12, color: context.colors.textSecondary)),
        ),
      );
    }
    final barWidgets = <Widget>[];
    final labelWidgets = <Widget>[];
    for (var i = 0; i < data.length; i++) {
      final e = data[i];
      final current = i == data.length - 1;
      final h = e.total == 0 ? 4.0 : 8 + (e.total / maxTotal) * 92; // 8..100 px
      barWidgets.add(Container(
        width: 22,
        height: h,
        decoration: BoxDecoration(
          color: current
              ? context.colors.primary
              : context.colors.accent.withValues(alpha: 0.35 + h / 250),
          borderRadius: BorderRadius.circular(6),
        ),
      ));
      labelWidgets.add(Text(e.label,
          style: TextStyle(
              fontSize: 10,
              fontWeight: current ? FontWeight.w700 : FontWeight.w400,
              color: current ? context.colors.primary : context.colors.textSecondary)));
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
  const _DueDebts({required this.utang, required this.now});

  final List<UtangEntity> utang;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    if (utang.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        alignment: Alignment.center,
        child: Text('Tidak ada utang jatuh tempo',
            style: TextStyle(fontSize: 12, color: context.colors.textSecondary)),
      );
    }
    final today = DateTime(now.year, now.month, now.day);
    final dateFormat = DateFormat('d MMM yyyy', 'id_ID');
    return SizedBox(
      height: 150,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: utang.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final u = utang[i];
          final jt = u.jatuhTempoBerikutnya!;
          final due = DateTime(jt.year, jt.month, jt.day);
          final d = due.difference(today).inDays;
          final badge = d < 0 ? 'Telat' : (d == 0 ? 'Hari ini' : 'H-$d');
          return _DebtCard(
            nama: u.namaUtang,
            badge: badge,
            sisa: u.sisaUtang,
            progress: u.progressPercent,
            jatuhTempo: dateFormat.format(jt),
            overdue: d < 0,
          );
        },
      ),
    );
  }
}

class _DebtCard extends StatelessWidget {
  const _DebtCard(
      {required this.nama,
      required this.badge,
      required this.sisa,
      required this.progress,
      required this.jatuhTempo,
      required this.overdue});

  final String nama;
  final String badge;
  final double sisa;
  final double progress;
  final String jatuhTempo;
  final bool overdue;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: context.colors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(nama,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                    color: overdue ? Colors.red.shade50 : context.colors.tint,
                    borderRadius: BorderRadius.circular(8)),
                child: Text(badge,
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: overdue ? Colors.red.shade600 : context.colors.primary)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(_rp.format(sisa),
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
              backgroundColor: context.colors.divider,
              valueColor: AlwaysStoppedAnimation(context.colors.accent),
            ),
          ),
          const SizedBox(height: 10),
          Text('Jatuh tempo $jatuhTempo',
              style: TextStyle(
                  fontSize: 11, color: context.colors.textSecondary)),
        ],
      ),
    );
  }
}

class _RecentTransactions extends StatelessWidget {
  const _RecentTransactions({required this.gaji, required this.pengeluaran});

  final List<GajiEntity> gaji;
  final List<PengeluaranEntity> pengeluaran;

  @override
  Widget build(BuildContext context) {
    // Nama kategori untuk pengeluaran diambil reaktif dari usecase.
    return StreamBuilder<List<KategoriEntity>>(
      stream: sl<WatchKategoriPengeluaran>()(),
      builder: (context, snapshot) {
        final namaById = {
          for (final k in snapshot.data ?? const <KategoriEntity>[]) k.id: k.nama,
        };
        final dateFormat = DateFormat('d MMM', 'id_ID');
        final txns = <_Txn>[
          ...gaji.map((g) => _Txn(
                date: g.tanggal,
                title: (g.catatan?.isNotEmpty ?? false) ? g.catatan! : 'Pendapatan',
                subtitle: dateFormat.format(g.tanggal),
                amount: '+${_rp.format(g.jumlah)}',
                income: true,
                glyph: 'P',
              )),
          ...pengeluaran.map((p) {
            final nama = namaById[p.kategoriId] ?? 'Lainnya';
            return _Txn(
              date: p.tanggal,
              title: nama,
              subtitle: dateFormat.format(p.tanggal),
              amount: '-${_rp.format(p.jumlah)}',
              income: false,
              glyph: nama.isNotEmpty ? nama[0].toUpperCase() : '?',
            );
          }),
        ]..sort((a, b) => b.date.compareTo(a.date));

        if (txns.isEmpty) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 24),
            alignment: Alignment.center,
            child: Text('Belum ada transaksi',
                style: TextStyle(fontSize: 12, color: context.colors.textSecondary)),
          );
        }

        final recent = txns.take(5).toList();
        return Column(
          children: [
            for (var i = 0; i < recent.length; i++)
              _TxnRow(txn: recent[i], divider: i < recent.length - 1),
          ],
        );
      },
    );
  }
}

class _Txn {
  final DateTime date;
  final String title;
  final String subtitle;
  final String amount;
  final bool income;
  final String glyph;
  const _Txn({
    required this.date,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.income,
    required this.glyph,
  });
}

class _TxnRow extends StatelessWidget {
  const _TxnRow({required this.txn, required this.divider});

  final _Txn txn;
  final bool divider;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: divider
            ? Border(bottom: BorderSide(color: context.colors.divider))
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                color: context.colors.accent.withValues(alpha: 0.15),
                shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Text(txn.glyph,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: context.colors.primary)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(txn.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(txn.subtitle,
                    style: TextStyle(
                        fontSize: 11, color: context.colors.textSecondary)),
              ],
            ),
          ),
          Text(txn.amount,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: txn.income ? context.colors.primary : context.colors.textPrimary,
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
                  TextStyle(fontSize: 12, color: context.colors.textSecondary)),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:uangku/core/theme/app_theme.dart';
import 'package:uangku/features/beranda/presentation/pages/beranda_page.dart';
import 'package:uangku/features/gaji/presentation/pages/gaji_page.dart';
import 'package:uangku/features/pengeluaran/presentation/pages/pengeluaran_page.dart';
import 'package:uangku/features/utang/presentation/pages/utang_page.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final _pages = const <Widget>[
    BerandaPage(),
    GajiPage(),
    PengeluaranPage(),
    UtangPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: _BottomNav(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _BottomNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.card,
        border: Border(top: BorderSide(color: context.colors.divider)),
      ),
      padding: const EdgeInsets.only(top: 10, bottom: 12),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(context, 0, Icons.home_rounded, 'Beranda'),
            _navItem(context, 1, Icons.account_balance_wallet_rounded, 'Pendapatan'),
            _navItem(context, 2, Icons.receipt_long_rounded, 'Pengeluaran'),
            _navItem(context, 3, Icons.credit_card_rounded, 'Utang'),
          ],
        ),
      ),
    );
  }

  Widget _navItem(BuildContext context, int index, IconData icon, String label) {
    final active = index == currentIndex;
    final color = active ? context.colors.primary : context.colors.textMuted;
    return InkWell(
      onTap: () => onTap(index),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(height: 4),
            Text(label,
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: color)),
          ],
        ),
      ),
    );
  }
}

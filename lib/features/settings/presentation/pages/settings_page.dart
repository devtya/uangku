import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:uangku/core/settings/theme_cubit.dart';
import 'package:uangku/core/theme/app_theme.dart';
import 'package:uangku/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:uangku/features/auth/presentation/bloc/auth_event.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          _sectionLabel(context, 'Tampilan'),
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, mode) {
              return Column(
                children: [
                  _themeTile(context, mode, ThemeMode.light, 'Terang',
                      Icons.light_mode_outlined),
                  _themeTile(context, mode, ThemeMode.dark, 'Gelap',
                      Icons.dark_mode_outlined),
                  _themeTile(context, mode, ThemeMode.system, 'Ikut sistem',
                      Icons.brightness_auto_outlined),
                ],
              );
            },
          ),
          const Divider(height: 24),
          _sectionLabel(context, 'Akun'),
          ListTile(
            leading: const Icon(Icons.logout_rounded),
            title: const Text('Keluar'),
            onTap: () {
              Navigator.of(context).pop();
              context.read<AuthBloc>().add(const AuthSignOutRequested());
            },
          ),
          const Divider(height: 24),
          _sectionLabel(context, 'Tentang'),
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snap) {
              final v = snap.hasData
                  ? '${snap.data!.version} (${snap.data!.buildNumber})'
                  : '…';
              return ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('Versi aplikasi'),
                subtitle: Text(v),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 6),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          color: context.colors.textMuted,
        ),
      ),
    );
  }

  Widget _themeTile(BuildContext context, ThemeMode current, ThemeMode mode,
      String label, IconData icon) {
    final selected = current == mode;
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      trailing: selected
          ? Icon(Icons.check_rounded, color: context.colors.primary)
          : null,
      onTap: () => context.read<ThemeCubit>().setMode(mode),
    );
  }
}

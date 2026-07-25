import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ota_update/ota_update.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:uangku/core/di/injection.dart';
import 'package:uangku/core/notifications/notification_service.dart';
import 'package:uangku/core/settings/avatar_cubit.dart';
import 'package:uangku/core/settings/theme_cubit.dart';
import 'package:uangku/features/auth/presentation/bloc/auth_state.dart';
import 'package:uangku/shared/widgets/app_avatar.dart';
import 'package:uangku/features/utang/domain/usecases/watch_all_utang.dart';
import 'package:uangku/core/theme/app_theme.dart';
import 'package:uangku/core/update/update_service.dart';
import 'package:uangku/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:uangku/features/auth/presentation/bloc/auth_event.dart';
import 'package:uangku/features/recurring/presentation/pages/recurring_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          _sectionLabel(context, 'Profil'),
          const _ProfileTile(),
          const Divider(height: 24),
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
          _sectionLabel(context, 'Otomatis'),
          ListTile(
            leading: const Icon(Icons.repeat_rounded),
            title: const Text('Transaksi berulang'),
            subtitle: const Text('Pendapatan/pengeluaran otomatis terjadwal'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const RecurringPage()),
            ),
          ),
          const _UtangNotifTile(),
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
          ListTile(
            leading: const Icon(Icons.system_update_outlined),
            title: const Text('Cek pembaruan'),
            onTap: () => _checkUpdate(context),
          ),
        ],
      ),
    );
  }

  Future<void> _checkUpdate(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    UpdateInfo? info;
    String? error;
    try {
      info = await sl<UpdateService>().checkForUpdate();
    } catch (e) {
      error = 'Gagal memeriksa pembaruan';
    }
    if (!context.mounted) return;
    Navigator.of(context).pop(); // tutup loading

    if (error != null) {
      messenger.showSnackBar(SnackBar(content: Text(error)));
      return;
    }
    if (info == null) {
      messenger.showSnackBar(
          const SnackBar(content: Text('Sudah versi terbaru')));
      return;
    }

    final mulai = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Pembaruan ${info!.version}'),
        content: SingleChildScrollView(
          child: Text(_prettyNotes(info.notes)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Nanti'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Perbarui'),
          ),
        ],
      ),
    );
    if (mulai == true && context.mounted) _startUpdate(context, info);
  }

  /// Bersihkan markdown release notes jadi teks rapi: buang baris judul (#),
  /// ubah "- " jadi "• ", buang sisa tanda markdown inline.
  String _prettyNotes(String raw) {
    final lines = <String>[];
    for (final line in raw.split('\n')) {
      var s = line.trim();
      if (s.isEmpty || s.startsWith('#')) continue;
      s = s.replaceFirst(RegExp(r'^[-*]\s+'), '• ');
      s = s.replaceAll(RegExp(r'[`*_]'), '');
      lines.add(s);
    }
    return lines.isEmpty ? 'Versi baru tersedia.' : lines.join('\n');
  }

  void _startUpdate(BuildContext context, UpdateInfo info) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Mengunduh pembaruan'),
        content: StreamBuilder<OtaEvent>(
          stream: sl<UpdateService>().downloadAndInstall(info.apkUrl),
          builder: (ctx, snap) {
            final status = snap.data?.status;
            if (status == OtaStatus.DOWNLOADING) {
              final pct = int.tryParse(snap.data?.value ?? '') ?? 0;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LinearProgressIndicator(value: pct / 100),
                  const SizedBox(height: 12),
                  Text('$pct%'),
                ],
              );
            }
            if (status == OtaStatus.INSTALLING) {
              return const Text('Membuka pemasang…');
            }
            if (status != null && status != OtaStatus.DOWNLOADING) {
              // error mana pun
              return const Text(
                  'Gagal mengunduh/memasang. Pastikan izin "Pasang aplikasi '
                  'tak dikenal" aktif, lalu coba lagi.');
            }
            return const SizedBox(
              height: 40,
              child: Center(child: CircularProgressIndicator()),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Tutup'),
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

/// Emoji preset avatar bawaan.
const _presetEmojis = ['🐱', '🐶', '🦊', '🐼', '🦁', '🐨', '🐯', '🐵', '🐸', '🐧'];

class _ProfileTile extends StatelessWidget {
  const _ProfileTile();

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final user = authState is AuthAuthenticated ? authState.user : null;
    final nama = (user?.displayName?.trim().isNotEmpty == true
            ? user!.displayName!.trim()
            : user?.email.split('@').first) ??
        'Pengguna';
    return ListTile(
      leading: const AppAvatar(size: 48),
      title: Text(nama, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(user?.email ?? '-'),
      trailing: const Icon(Icons.edit_outlined),
      onTap: () => _showAvatarPicker(context),
    );
  }

  void _showAvatarPicker(BuildContext context) {
    final cubit = context.read<AvatarCubit>();
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetCtx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                child: Text('Ganti avatar',
                    style: Theme.of(sheetCtx).textTheme.titleMedium),
              ),
              ListTile(
                leading: const Icon(Icons.account_circle_outlined),
                title: const Text('Foto Google'),
                onTap: () {
                  cubit.useGoogle();
                  Navigator.of(sheetCtx).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Pilih dari galeri'),
                onTap: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  Navigator.of(sheetCtx).pop();
                  try {
                    final img = await ImagePicker().pickImage(
                      source: ImageSource.gallery,
                      maxWidth: 512,
                      maxHeight: 512,
                      imageQuality: 85,
                    );
                    if (img != null) await cubit.useCustomFile(img.path);
                  } catch (e) {
                    messenger.showSnackBar(
                        const SnackBar(content: Text('Gagal memuat foto')));
                  }
                },
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 12, 20, 4),
                child: Text('Avatar bawaan'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Wrap(
                  children: [
                    for (final e in _presetEmojis)
                      InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () {
                          cubit.usePreset(e);
                          Navigator.of(sheetCtx).pop();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: CircleAvatar(
                            radius: 24,
                            backgroundColor:
                                Theme.of(sheetCtx).colorScheme.surfaceContainerHighest,
                            child: Text(e, style: const TextStyle(fontSize: 26)),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}

class _UtangNotifTile extends StatefulWidget {
  const _UtangNotifTile();

  @override
  State<_UtangNotifTile> createState() => _UtangNotifTileState();
}

class _UtangNotifTileState extends State<_UtangNotifTile> {
  late bool _on = sl<NotificationService>().enabled;
  bool _busy = false;

  Future<void> _toggle(bool value) async {
    setState(() {
      _on = value;
      _busy = true;
    });
    final list = await sl<WatchAllUtang>()().first;
    await sl<NotificationService>().setEnabled(value, list);
    if (mounted) setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      secondary: const Icon(Icons.notifications_active_outlined),
      title: const Text('Pengingat jatuh tempo utang'),
      subtitle: const Text('Notifikasi H-1 & hari-H, jam 08:00'),
      value: _on,
      onChanged: _busy ? null : _toggle,
    );
  }
}

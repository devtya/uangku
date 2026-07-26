import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as p;
import 'package:uangku/core/settings/avatar_cubit.dart';
import 'package:uangku/core/theme/app_theme.dart';
import 'package:uangku/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:uangku/features/auth/presentation/bloc/auth_state.dart';

/// Avatar user reusable: baca [AvatarCubit] + [AuthBloc] dan render sesuai
/// prioritas pilihan (preset emoji / foto galeri / foto Google / inisial).
class AppAvatar extends StatelessWidget {
  final double size;

  const AppAvatar({super.key, this.size = 40});

  @override
  Widget build(BuildContext context) {
    final avatar = context.watch<AvatarCubit>().state;
    final authState = context.watch<AuthBloc>().state;
    final user = authState is AuthAuthenticated ? authState.user : null;

    final nama = (user?.displayName?.trim().isNotEmpty == true
            ? user!.displayName!.trim()
            : user?.email.split('@').first) ??
        '';
    final initial = nama.isNotEmpty ? nama[0].toUpperCase() : '?';
    Widget fallback() => _initialCircle(context, initial);

    if (avatar != null && avatar.startsWith('preset:')) {
      return _circle(context,
          child: Text(avatar.substring(7),
              style: TextStyle(fontSize: size * 0.55)));
    }

    if (avatar != null && avatar.startsWith('file:')) {
      final dir = appDocumentsPath;
      if (dir != null) {
        final file = File(p.join(dir, avatar.substring(5)));
        if (file.existsSync()) {
          return _clip(Image.file(file,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => fallback()));
        }
      }
      return fallback();
    }

    final photoUrl = user?.photoUrl;
    if (photoUrl != null && photoUrl.isNotEmpty) {
      return _clip(Image.network(photoUrl,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => fallback(),
          loadingBuilder: (_, child, progress) =>
              progress == null ? child : fallback()));
    }

    return fallback();
  }

  Widget _clip(Widget child) =>
      ClipOval(child: SizedBox(width: size, height: size, child: child));

  Widget _circle(BuildContext context, {required Widget child}) => Container(
        width: size,
        height: size,
        decoration:
            BoxDecoration(color: context.colors.tint, shape: BoxShape.circle),
        alignment: Alignment.center,
        child: child,
      );

  Widget _initialCircle(BuildContext context, String initial) => _circle(context,
      child: Text(initial,
          style: TextStyle(
              fontSize: size * 0.4,
              fontWeight: FontWeight.w700,
              color: context.colors.primary)));
}

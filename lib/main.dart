import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:uangku/core/di/injection.dart';
import 'package:uangku/core/settings/theme_cubit.dart';
import 'package:uangku/core/sync/sync_service.dart';
import 'package:uangku/core/theme/app_theme.dart';
import 'package:uangku/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:uangku/features/auth/presentation/bloc/auth_event.dart';
import 'package:uangku/features/auth/presentation/bloc/auth_state.dart';
import 'package:uangku/features/auth/presentation/pages/login_page.dart';
import 'package:uangku/features/gaji/presentation/bloc/gaji_bloc.dart';
import 'package:uangku/features/pengeluaran/presentation/bloc/pengeluaran_bloc.dart';
import 'package:uangku/features/utang/presentation/bloc/utang_bloc.dart';
import 'package:uangku/firebase_options.dart';
import 'package:uangku/shared/widgets/main_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDateFormatting('id_ID', null);
  await initDependencies();
  runApp(const UangkuApp());
}

class UangkuApp extends StatelessWidget {
  const UangkuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => sl<AuthBloc>(),
        ),
        BlocProvider<GajiBloc>(
          create: (_) => sl<GajiBloc>(),
        ),
        BlocProvider<PengeluaranBloc>(
          create: (_) => sl<PengeluaranBloc>(),
        ),
        BlocProvider<UtangBloc>(
          create: (_) => sl<UtangBloc>(),
        ),
        BlocProvider<ThemeCubit>(
          create: (_) => sl<ThemeCubit>(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'Uangku',
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeMode,
            home: const AuthGate(),
          );
        },
      ),
    );
  }
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(const AuthCheckRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        final sync = sl<SyncService>();
        if (state is AuthAuthenticated) {
          sync.handleLogin(state.user.uid);
        } else if (state is AuthUnauthenticated) {
          sync.handleLogout();
        }
      },
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return const MainShell();
        }
        return const LoginPage();
      },
    );
  }
}

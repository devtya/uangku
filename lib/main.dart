import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:uangku/core/di/injection.dart';
import 'package:uangku/core/theme/app_theme.dart';
import 'package:uangku/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:uangku/features/auth/presentation/bloc/auth_event.dart';
import 'package:uangku/features/auth/presentation/bloc/auth_state.dart';
import 'package:uangku/features/auth/presentation/pages/login_page.dart';
import 'package:uangku/features/gaji/presentation/bloc/gaji_bloc.dart';
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
      ],
      child: MaterialApp(
        title: 'Uangku',
        theme: AppTheme.light,
        home: const AuthGate(),
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
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return const MainShell();
        }
        return const LoginPage();
      },
    );
  }
}

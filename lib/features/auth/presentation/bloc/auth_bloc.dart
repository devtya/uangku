import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uangku/features/auth/domain/entities/user_entity.dart';
import 'package:uangku/features/auth/domain/repositories/auth_repository.dart';
import 'package:uangku/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:uangku/features/auth/domain/usecases/sign_out.dart';
import 'package:uangku/features/auth/presentation/bloc/auth_event.dart';
import 'package:uangku/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final SignInWithGoogle _signInWithGoogle;
  final SignOut _signOut;
  StreamSubscription<UserEntity?>? _authSubscription;

  AuthBloc({
    required AuthRepository authRepository,
    required SignInWithGoogle signInWithGoogle,
    required SignOut signOut,
  })  : _authRepository = authRepository,
        _signInWithGoogle = signInWithGoogle,
        _signOut = signOut,
        super(const AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthGoogleSignInRequested>(_onGoogleSignInRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);
    on<_AuthStateChanged>(_onAuthStateChanged);

    _authSubscription = authRepository.authStateChanges.listen((user) {
      add(_AuthStateChanged(user));
    });
  }

  void _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) {
    final user = _authRepository.currentUser;
    if (user != null) {
      emit(AuthAuthenticated(user));
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  void _onAuthStateChanged(
    _AuthStateChanged event,
    Emitter<AuthState> emit,
  ) {
    if (event.user != null) {
      emit(AuthAuthenticated(event.user!));
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onGoogleSignInRequested(
    AuthGoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _signInWithGoogle();
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> _onSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _signOut();
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(const AuthUnauthenticated()),
    );
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}

class _AuthStateChanged extends AuthEvent {
  final UserEntity? user;
  const _AuthStateChanged(this.user);
}

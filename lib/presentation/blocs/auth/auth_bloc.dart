import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/user_model.dart';
import '../../../data/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  late StreamSubscription<User?> _authStateSubscription;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthInitial()) {
    on<AuthStarted>(_onAuthStarted);
    on<AuthSignInWithGoogle>(_onSignInWithGoogle);
    on<AuthSignInWithEmail>(_onSignInWithEmail);
    on<AuthSignUpWithEmail>(_onSignUpWithEmail);
    on<AuthSignOut>(_onSignOut);

    _authStateSubscription = _authRepository.authStateChanges.listen((user) async {
      debugPrint('🔄 AuthBloc - Auth state changed, user: ${user?.uid}');
      if (user != null) {
        try {
          debugPrint('👤 AuthBloc - Getting user data for: ${user.uid}');
          final userModel = await _authRepository.getUserData(user.uid);
          if (userModel != null) {
            debugPrint('✅ AuthBloc - User data found, emitting AuthAuthenticated');
            emit(AuthAuthenticated(user: userModel));
          } else {
            debugPrint('⚠️ AuthBloc - User data not found, creating temporary user model');
            // Create temporary user model from Firebase Auth user
            final tempUser = UserModel(
              id: user.uid,
              email: user.email ?? 'unknown@email.com',
              username: user.displayName ?? user.email?.split('@')[0] ?? 'User',
              photoUrl: user.photoURL,
              createdAt: DateTime.now(),
            );
            debugPrint('✅ AuthBloc - Emitting AuthAuthenticated with temp user');
            emit(AuthAuthenticated(user: tempUser));
          }
        } catch (e) {
          debugPrint('❌ AuthBloc - Error getting user data: $e');
          // Still try to authenticate with basic user info
          final tempUser = UserModel(
            id: user.uid,
            email: user.email ?? 'unknown@email.com',
            username: user.displayName ?? user.email?.split('@')[0] ?? 'User',
            photoUrl: user.photoURL,
            createdAt: DateTime.now(),
          );
          debugPrint('✅ AuthBloc - Emitting AuthAuthenticated with temp user (after error)');
          emit(AuthAuthenticated(user: tempUser));
        }
      } else {
        debugPrint('🔐 AuthBloc - No user, emitting AuthUnauthenticated');
        emit(AuthUnauthenticated());
      }
    });
  }

  Future<void> _onAuthStarted(AuthStarted event, Emitter<AuthState> emit) async {
    try {
      final user = _authRepository.currentUser;
      if (user != null) {
        final userModel = await _authRepository.getUserData(user.uid);
        if (userModel != null) {
          emit(AuthAuthenticated(user: userModel));
        } else {
          emit(AuthUnauthenticated());
        }
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onSignInWithGoogle(AuthSignInWithGoogle event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.signInWithGoogle();
      if (user != null) {
        emit(AuthAuthenticated(user: user));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onSignInWithEmail(AuthSignInWithEmail event, Emitter<AuthState> emit) async {
    debugPrint('🔐 AuthBloc - Starting email sign in');
    emit(AuthLoading());
    try {
      final user = await _authRepository.signInWithEmailPassword(
        event.email,
        event.password,
      );
      if (user != null) {
        debugPrint('✅ AuthBloc - Sign in successful, emitting AuthAuthenticated');
        emit(AuthAuthenticated(user: user));
      } else {
        debugPrint('❌ AuthBloc - Sign in failed, user is null');
        emit(AuthError(message: 'Sign in failed'));
      }
    } catch (e) {
      debugPrint('❌ AuthBloc - Sign in error: $e');
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onSignUpWithEmail(AuthSignUpWithEmail event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.signUpWithEmailPassword(
        event.email,
        event.password,
        event.username,
      );
      if (user != null) {
        emit(AuthAuthenticated(user: user));
      } else {
        emit(AuthError(message: 'Sign up failed'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onSignOut(AuthSignOut event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _authRepository.signOut();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _authStateSubscription.cancel();
    return super.close();
  }
}

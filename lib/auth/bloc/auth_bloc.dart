import 'package:e_commerce_store_with_bloc/cart/data/repositories/cart_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce_store_with_bloc/auth/bloc/auth_event.dart';
import 'package:e_commerce_store_with_bloc/auth/bloc/auth_state.dart';
import 'package:e_commerce_store_with_bloc/auth/data/repositories/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final CartRepository cartRepository;

  AuthBloc({required this.authRepository, required this.cartRepository})
      : super(AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthCheckStatus>(_onCheckStatus);
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final authResponse =
          await authRepository.login(event.username, event.password);
      final userId = await authRepository.getLoggedInUserId();
      if (userId != null) {
        emit(AuthAuthenticated(token: authResponse.token, userId: userId));
      } else {
        emit(const AuthError(message: 'User ID not found after login.'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await authRepository.logout();
    cartRepository.clearLocalCart();
    emit(AuthUnauthenticated());
  }

  Future<void> _onCheckStatus(
    AuthCheckStatus event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final isAuthenticated = await authRepository.isAuthenticated();
      if (isAuthenticated) {
        final token = await authRepository.getAuthToken();
        final userId = await authRepository.getLoggedInUserId();
        if (token != null && userId != null) {
          cartRepository.clearLocalCart();
          emit(AuthAuthenticated(token: token, userId: userId));
        } else {
          emit(AuthUnauthenticated());
        }
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(message: 'Failed to check authentication status: $e'));
    }
  }
}

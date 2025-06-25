import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../shared/models/user.dart';
import '../../../shared/services/http_service.dart';
import '../../../shared/services/mock_data_service.dart';

// Auth States
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated(this.user);

  @override
  List<Object> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}

// Auth Cubit
@injectable
class AuthCubit extends Cubit<AuthState> {
  final HttpService _httpService;

  AuthCubit(this._httpService) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());

    try {
      // Use mock data for demo
      final user = await MockDataService().authenticateUser(email, password);
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(const AuthError('Invalid credentials'));
      }
    } catch (e) {
      emit(AuthError('Login failed: ${e.toString()}'));
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());

    try {
      await _httpService.post('/auth/logout');
      await _httpService.logout();
      emit(AuthUnauthenticated());
    } catch (e) {
      // Even if logout fails on server, clear local data
      await _httpService.logout();
      emit(AuthUnauthenticated());
    }
  }

  Future<void> checkAuthStatus() async {
    emit(AuthLoading());

    try {
      final isAuthenticated = await _httpService.isAuthenticated();
      if (isAuthenticated) {
        final response = await _httpService.get<Map<String, dynamic>>(
          '/auth/me',
        );
        if (response.isSuccess) {
          final user = User.fromJson(response.data!);
          emit(AuthAuthenticated(user));
        } else {
          emit(AuthUnauthenticated());
        }
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    emit(AuthLoading());

    try {
      final response = await _httpService.post<Map<String, dynamic>>(
        '/auth/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );

      if (response.isSuccess) {
        final userData = response.data!;
        final token = userData['access_token'] as String;
        final user = User.fromJson(userData['user']);

        await _httpService.setAuthToken(token);
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthError(response.message ?? 'Registration failed'));
      }
    } catch (e) {
      emit(AuthError('Registration failed: ${e.toString()}'));
    }
  }
}

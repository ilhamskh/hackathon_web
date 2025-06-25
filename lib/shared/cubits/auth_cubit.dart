import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import '../models/user.dart';
import '../services/http_service.dart';

// States
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

// Cubit
class AuthCubit extends Cubit<AuthState> {
  final HttpService _httpService;
  final BehaviorSubject<User?> _userSubject = BehaviorSubject<User?>();

  AuthCubit(this._httpService) : super(AuthInitial()) {
    _checkAuthStatus();
  }

  // Streams
  Stream<User?> get userStream => _userSubject.stream;
  User? get currentUser => _userSubject.valueOrNull;
  bool get isAuthenticated => currentUser != null;

  Future<void> _checkAuthStatus() async {
    try {
      final isAuth = await _httpService.isAuthenticated();
      if (isAuth) {
        await _loadUserProfile();
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    
    try {
      final response = await _httpService.post<Map<String, dynamic>>(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.success && response.data != null) {
        final token = response.data!['access_token'] as String;
        final userData = response.data!['user'] as Map<String, dynamic>;
        
        await _httpService.setAuthToken(token);
        
        final user = User.fromJson(userData);
        _userSubject.add(user);
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthError(response.message ?? 'Login failed'));
      }
    } catch (e) {
      emit(AuthError('Login failed: $e'));
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    emit(AuthLoading());
    
    try {
      final response = await _httpService.post<Map<String, dynamic>>(
        '/auth/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
          'role': role,
        },
      );

      if (response.success && response.data != null) {
        final token = response.data!['access_token'] as String;
        final userData = response.data!['user'] as Map<String, dynamic>;
        
        await _httpService.setAuthToken(token);
        
        final user = User.fromJson(userData);
        _userSubject.add(user);
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthError(response.message ?? 'Registration failed'));
      }
    } catch (e) {
      emit(AuthError('Registration failed: $e'));
    }
  }

  Future<void> _loadUserProfile() async {
    try {
      final response = await _httpService.get<Map<String, dynamic>>(
        '/auth/profile',
        fromJson: (data) => data as Map<String, dynamic>,
      );

      if (response.success && response.data != null) {
        final user = User.fromJson(response.data!);
        _userSubject.add(user);
        emit(AuthAuthenticated(user));
      } else {
        await logout();
      }
    } catch (e) {
      await logout();
    }
  }

  Future<void> updateProfile({
    String? name,
    String? email,
  }) async {
    if (currentUser == null) return;

    emit(AuthLoading());
    
    try {
      final response = await _httpService.put<Map<String, dynamic>>(
        '/auth/profile',
        data: {
          if (name != null) 'name': name,
          if (email != null) 'email': email,
        },
        fromJson: (data) => data as Map<String, dynamic>,
      );

      if (response.success && response.data != null) {
        final user = User.fromJson(response.data!);
        _userSubject.add(user);
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthError(response.message ?? 'Profile update failed'));
        // Restore previous state
        emit(AuthAuthenticated(currentUser!));
      }
    } catch (e) {
      emit(AuthError('Profile update failed: $e'));
      // Restore previous state
      if (currentUser != null) {
        emit(AuthAuthenticated(currentUser!));
      }
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (currentUser == null) return;

    emit(AuthLoading());
    
    try {
      final response = await _httpService.put<Map<String, dynamic>>(
        '/auth/change-password',
        data: {
          'current_password': currentPassword,
          'new_password': newPassword,
        },
      );

      if (response.success) {
        emit(AuthAuthenticated(currentUser!));
      } else {
        emit(AuthError(response.message ?? 'Password change failed'));
        emit(AuthAuthenticated(currentUser!));
      }
    } catch (e) {
      emit(AuthError('Password change failed: $e'));
      if (currentUser != null) {
        emit(AuthAuthenticated(currentUser!));
      }
    }
  }

  Future<void> logout() async {
    try {
      await _httpService.post('/auth/logout');
    } catch (e) {
      // Ignore logout API errors
    }
    
    await _httpService.logout();
    _userSubject.add(null);
    emit(AuthUnauthenticated());
  }

  Future<void> forgotPassword(String email) async {
    try {
      await _httpService.post(
        '/auth/forgot-password',
        data: {'email': email},
      );
    } catch (e) {
      // Handle forgot password errors
      throw Exception('Failed to send reset email');
    }
  }

  @override
  Future<void> close() {
    _userSubject.close();
    return super.close();
  }
}

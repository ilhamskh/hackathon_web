import 'package:flutter/foundation.dart';
import 'package:hackathon_web/shared/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../shared/services/http_service.dart';
import '../../../config/app_config.dart';

class AuthProvider with ChangeNotifier {
  final HttpService _httpService = HttpService();

  User? _user;
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _error;

  // Getters
  User? get user => _user;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Initialize auth state from stored data
  Future<void> initialize() async {
    _setLoading(true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConfig.authTokenKey);
      final userData = prefs.getString(AppConfig.userDataKey);

      if (token != null && userData != null) {
        _isAuthenticated = true;

        // Set token in HTTP service
        _httpService.setAuthToken(token);

        // Verify token is still valid
        await _verifyToken();
      }
    } catch (e) {
      await logout(); // Clear invalid data
    }

    _setLoading(false);
  }

  // Login
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _httpService.post<Map<String, dynamic>>(
        AppConfig.loginEndpoint,
        data: {'email': email, 'password': password},
      );

      if (response.success && response.data != null) {
        final data = response.data!;
        final token = data['token'] as String;
        final userData = data['user'] as Map<String, dynamic>;

        _user = User.fromJson(userData);
        _isAuthenticated = true;

        // Store auth data
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(AppConfig.authTokenKey, token);
        await prefs.setString(
          AppConfig.userDataKey,
          _user!.toJson().toString(),
        );

        // Set token in HTTP service
        _httpService.setAuthToken(token);

        _setLoading(false);
        return true;
      } else {
        _setError(response.errors?[''] ?? 'Login failed');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('An unexpected error occurred');
      _setLoading(false);
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    _setLoading(true);

    try {
      // Call logout endpoint if authenticated
      if (_isAuthenticated) {
        await _httpService.post(AppConfig.logoutEndpoint);
      }
    } catch (e) {
      // Continue with logout even if API call fails
    }

    // Clear local data
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConfig.authTokenKey);
    await prefs.remove(AppConfig.userDataKey);
    await prefs.remove(AppConfig.refreshTokenKey);

    // Clear auth state
    _user = null;
    _isAuthenticated = false;
    _httpService.clearAuthToken();

    _setLoading(false);
    notifyListeners();
  }

  // Verify token validity
  Future<bool> _verifyToken() async {
    try {
      final response = await _httpService.get('/auth/verify');
      if (!response.success) {
        await logout();
        return false;
      }
      return true;
    } catch (e) {
      await logout();
      return false;
    }
  }

  // Refresh token
  Future<bool> refreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString(AppConfig.refreshTokenKey);

      if (refreshToken == null) {
        await logout();
        return false;
      }

      final response = await _httpService.post<Map<String, dynamic>>(
        AppConfig.refreshTokenEndpoint,
        data: {'refresh_token': refreshToken},
      );

      if (response.success && response.data != null) {
        final newToken = response.data!['token'] as String;
        await prefs.setString(AppConfig.authTokenKey, newToken);
        _httpService.setAuthToken(newToken);
        return true;
      } else {
        await logout();
        return false;
      }
    } catch (e) {
      await logout();
      return false;
    }
  }

  // Register (if needed)
  Future<bool> register(String email, String password, String name) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _httpService.post<Map<String, dynamic>>(
        '/auth/register',
        data: {'email': email, 'password': password, 'name': name},
      );

      if (response.success) {
        _setLoading(false);
        return true;
      } else {
        _setError(response.errors?[''] ?? 'Registration failed');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('An unexpected error occurred');
      _setLoading(false);
      return false;
    }
  }

  // Private methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    if (_error != null) {
      _error = null;
      notifyListeners();
    }
  }
}

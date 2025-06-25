class AppConfig {
  // API Configuration
  static const String baseUrl = 'https://your-api-domain.com/api/v1';
  static const String apiKey = 'your-api-key-here';
  
  // Authentication Configuration
  static const String authTokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';
  
  // API Endpoints
  static const String loginEndpoint = '/auth/login';
  static const String logoutEndpoint = '/auth/logout';
  static const String refreshTokenEndpoint = '/auth/refresh';
  static const String hackathonsEndpoint = '/hackathons';
  static const String createHackathonEndpoint = '/hackathons/create';
  static const String updateHackathonEndpoint = '/hackathons/update';
  static const String deleteHackathonEndpoint = '/hackathons/delete';
  
  // App Configuration
  static const String appName = 'Hackathon Admin Panel';
  static const String appVersion = '1.0.0';
  
  // UI Configuration
  static const int maxTeamSize = 6;
  static const int minTeamSize = 2;
  static const List<String> hackathonTypes = ['Online', 'Offline', 'Hybrid'];
  
  // File Upload Configuration
  static const int maxFileSize = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'gif'];
  
  // Timeout Configuration
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  
  // Environment Configuration
  static const bool isDevelopment = true;
  static const bool enableLogging = true;
}

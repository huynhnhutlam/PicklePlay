class AppConstants {
  // API related constants
  static const String baseUrl = 'https://your-api-url.com';
  static const Duration apiTimeout = Duration(seconds: 30);
  
  // Local storage keys
  static const String authTokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';
  
  // Pagination
  static const int defaultPageSize = 10;
  
  // Date formats
  static const String dateFormat = 'yyyy-MM-dd';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm:ss';
  static const String timeFormat = 'HH:mm';
  
  // Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 20;
  
  // App settings
  static const String appName = 'PicklePlay';
  static const String appVersion = '1.0.0';
  
  // Add other app-wide constants here
}

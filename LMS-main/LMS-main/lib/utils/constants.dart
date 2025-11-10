class AppConstants {
  static const String appName = 'Course Management System';
  
  // Colors
  static const int primaryColor = 0xFF2196F3;
  
  // API endpoints (for future use)
  static const String baseUrl = 'https://api.example.com';
  
  // Validation
  static const int minPasswordLength = 6;
  static const int maxFileSize = 50 * 1024 * 1024; // 50MB
  
  // Supported video formats
  static const List<String> supportedVideoFormats = ['.mp4', '.avi', '.mov', '.wmv'];
  
  // Default values
  static const int defaultVideoDuration = 600; // 10 minutes in seconds
  static const int maxCheckpointsPerVideo = 10;
}
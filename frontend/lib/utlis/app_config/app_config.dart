class AppConfig {
  // Use localhost since the connectivity test showed it works
  static const String baseUrl = 'http://192.168.29.6:5000/api';
  static const String baseFileUrl = 'http://192.168.29.6:5000';

  // Alternative configurations if localhost doesn't work:
  // For Android emulator: 'http://10.0.2.2:5000/api'
  // For physical device: 'http://192.168.29.6:5000/api' (your computer's IP)
  // For iOS simulator: 'http://localhost:5000/api'
}


// 'http://192.168.29.6:5000/api';
// 'http://10.0.2.2:5000';
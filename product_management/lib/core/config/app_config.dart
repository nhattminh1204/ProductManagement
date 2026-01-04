import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String get apiUrl {
    return dotenv.env['API_URL'] ?? 'http://localhost:8080/api';
  }

  static Future<void> load() async {
    await dotenv.load(fileName: ".env");
  }
}

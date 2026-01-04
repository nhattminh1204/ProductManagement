import 'package:jwt_decoder/jwt_decoder.dart';

class JwtParser {
  /// Check if token is expired
  static bool isTokenExpired(String token) {
    return JwtDecoder.isExpired(token);
  }

  /// Decode token to get payload
  static Map<String, dynamic> decode(String token) {
    return JwtDecoder.decode(token);
  }

  /// Get role from token
  /// Assuming role is stored in 'role' or 'authorities' claim
  static String? getRole(String token) {
    final decoded = decode(token);
    // Adjust key based on your backend JWT structure
    if (decoded.containsKey('role')) {
      return decoded['role'].toString();
    }
    if (decoded.containsKey('roles')) {
       // Handle list of roles if necessary, return first or join
       final roles = decoded['roles'];
       if (roles is List && roles.isNotEmpty) {
         return roles.first.toString();
       }
    }
    return null;
  }
}

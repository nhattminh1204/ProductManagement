import 'package:flutter/material.dart';
import 'package:product_management/core/storage/local_storage.dart';
import 'package:product_management/core/utils/jwt_parser.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';

enum UserRole { admin, user, guest }

class AuthProvider extends ChangeNotifier {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;

  AuthProvider(this._loginUseCase, this._registerUseCase);

  bool _isLoading = false;
  String? _errorMessage;
  String? _token;
  String? _userEmail;
  UserRole _role = UserRole.guest;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _token != null;
  String? get userEmail => _userEmail;
  UserRole get role => _role;
  bool get isAdmin => _role == UserRole.admin;
  bool get isUser => _role == UserRole.user;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await _loginUseCase(email, password);
      await _setSession(token);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String name, String email, String phone, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _registerUseCase(name, email, phone, password);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> _setSession(String token) async {
    _token = token;
    await LocalStorage.saveToken(token);

    // Parse role
    final roleString = JwtParser.getRole(token);
    _role = _parseRole(roleString);

    // Also save user info if available in token
    final decoded = JwtParser.decode(token);
    _userEmail = decoded['sub']?.toString() ?? decoded['email']?.toString();
    
    if (decoded.containsKey('sub')) {
      await LocalStorage.saveUserInfo(
        decoded['id']?.toString() ?? '',
        decoded['sub']?.toString() ?? '',
      );
    }
  }

  UserRole _parseRole(String? roleString) {
    if (roleString == null) return UserRole.user;
    final normalized = roleString.toLowerCase();
    if (normalized.contains('admin')) return UserRole.admin;
    return UserRole.user;
  }

  Future<void> checkLoginStatus() async {
    final token = await LocalStorage.getToken();
    if (token != null && !JwtParser.isTokenExpired(token)) {
      _token = token;
      final roleString = JwtParser.getRole(token);
      _role = _parseRole(roleString);
      
      final decoded = JwtParser.decode(token);
      _userEmail = decoded['sub']?.toString() ?? decoded['email']?.toString();
      
      notifyListeners();
    } else {
      await logout();
    }
  }

  Future<void> logout() async {
    _token = null;
    _userEmail = null;
    _role = UserRole.guest;
    await LocalStorage.clearAll();
    notifyListeners();
  }
}



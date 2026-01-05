import '../../../../api/api_service.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiService _apiService;
  AuthRepositoryImpl(this._apiService);

  @override
  Future<String> login(String email, String password) {
    return _apiService.login(email, password);
  }

  @override
  Future<void> register(String name, String username, String email, String phone, String password) {
    return _apiService.register(name, username, email, phone, password);
  }
}


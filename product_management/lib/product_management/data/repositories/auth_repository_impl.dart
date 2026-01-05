import '../../../../api/api_service.dart';
import '../../domain/repositories/repositories.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiService _apiService;
  AuthRepositoryImpl(this._apiService);

  @override
  Future<String> login(String usernameOrEmail, String password) {
    return _apiService.login(usernameOrEmail, password);
  }

  @override
  Future<void> register(String name, String username, String email, String phone, String password) {
    return _apiService.register(name, username, email, phone, password);
  }
}

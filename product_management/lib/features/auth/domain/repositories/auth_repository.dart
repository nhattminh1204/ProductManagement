abstract class AuthRepository {
  Future<String> login(String email, String password);
  Future<void> register(String name, String email, String phone, String password);
}



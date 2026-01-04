import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;
  RegisterUseCase(this.repository);

  Future<void> call(String name, String email, String phone, String password) {
    return repository.register(name, email, phone, password);
  }
}


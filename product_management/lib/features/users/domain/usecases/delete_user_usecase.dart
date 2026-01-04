import '../repositories/user_repository.dart';

class DeleteUserUseCase {
  final UserRepository repository;
  DeleteUserUseCase(this.repository);

  Future<void> call(int id) {
    return repository.deleteUser(id);
  }
}



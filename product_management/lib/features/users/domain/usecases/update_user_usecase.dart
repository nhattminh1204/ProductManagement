import '../repositories/user_repository.dart';
import '../entities/user_entity.dart';

class UpdateUserUseCase {
  final UserRepository repository;
  UpdateUserUseCase(this.repository);

  Future<User> call(int id, User user) {
    return repository.updateUser(id, user);
  }
}



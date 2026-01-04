import '../repositories/user_repository.dart';
import '../entities/user_entity.dart';

class GetUserByIdUseCase {
  final UserRepository repository;
  GetUserByIdUseCase(this.repository);

  Future<User> call(int id) {
    return repository.getUserById(id);
  }
}



import '../repositories/user_repository.dart';
import '../entities/user_entity.dart';

class GetUsersUseCase {
  final UserRepository repository;
  GetUsersUseCase(this.repository);

  Future<List<User>> call() {
    return repository.getUsers();
  }
}



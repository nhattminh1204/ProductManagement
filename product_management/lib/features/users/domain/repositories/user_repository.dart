import '../entities/user_entity.dart';

abstract class UserRepository {
  Future<List<User>> getUsers();
  Future<User> getUserById(int id);
  Future<User> updateUser(int id, User user);
  Future<void> deleteUser(int id);
}



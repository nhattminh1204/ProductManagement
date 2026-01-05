import '../../../../api/api_service.dart';
import '../models/user_model.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final ApiService _apiService;
  UserRepositoryImpl(this._apiService);

  @override
  Future<List<User>> getUsers() async {
    final models = await _apiService.fetchUsers();
    return models.map((m) => _toEntity(m)).toList();
  }

  @override
  Future<User> getUserById(int id) async {
    final model = await _apiService.getUserById(id);
    return _toEntity(model);
  }

  @override
  Future<User> updateUser(int id, User user) async {
    final modelInput = _toModel(user);
    final modelOutput = await _apiService.updateUser(id, modelInput);
    return _toEntity(modelOutput);
  }

  @override
  Future<void> deleteUser(int id) async {
    await _apiService.deleteUser(id);
  }

  User _toEntity(UserModel model) {
    return User(
      id: model.id,
      name: model.name,
      username: model.username,
      email: model.email,
      phone: model.phone,
      address: model.address,
      role: model.role,
      status: model.status,
    );
  }

  UserModel _toModel(User entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      username: entity.username,
      email: entity.email,
      phone: entity.phone,
      address: entity.address,
      role: entity.role,
      status: entity.status,
    );
  }
}



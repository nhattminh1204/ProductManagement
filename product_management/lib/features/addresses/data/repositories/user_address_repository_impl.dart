import '../../../../api/api_service.dart';
import '../../domain/repositories/user_address_repository.dart';
import '../../domain/entities/user_address_entity.dart';
import '../models/user_address_model.dart';

class UserAddressRepositoryImpl implements UserAddressRepository {
  final ApiService _apiService;

  UserAddressRepositoryImpl(this._apiService);

  @override
  Future<List<UserAddress>> getUserAddresses(int userId) async {
    final models = await _apiService.getUserAddresses(userId);
    return models;
  }

  @override
  Future<UserAddress> createAddress(UserAddress address) async {
    final modelInput = _toModel(address);
    final modelOutput = await _apiService.createAddress(modelInput);
    return modelOutput;
  }

  @override
  Future<UserAddress> updateAddress(int id, UserAddress address) async {
    final modelInput = _toModel(address);
    final modelOutput = await _apiService.updateAddress(id, modelInput);
    return modelOutput;
  }

  @override
  Future<void> deleteAddress(int id) async {
    await _apiService.deleteAddress(id);
  }

  UserAddressModel _toModel(UserAddress entity) {
    if (entity is UserAddressModel) return entity;
    return UserAddressModel(
      id: entity.id,
      userId: entity.userId,
      recipientName: entity.recipientName,
      phone: entity.phone,
      address: entity.address,
      city: entity.city,
      isDefault: entity.isDefault,
    );
  }
}

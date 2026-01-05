import '../repositories/user_address_repository.dart';
import '../entities/user_address_entity.dart';

class GetUserAddressesUseCase {
  final UserAddressRepository repository;
  GetUserAddressesUseCase(this.repository);
  Future<List<UserAddress>> call(int userId) => repository.getUserAddresses(userId);
}

class CreateAddressUseCase {
  final UserAddressRepository repository;
  CreateAddressUseCase(this.repository);
  Future<UserAddress> call(UserAddress address) => repository.createAddress(address);
}

class UpdateAddressUseCase {
  final UserAddressRepository repository;
  UpdateAddressUseCase(this.repository);
  Future<UserAddress> call(int id, UserAddress address) => repository.updateAddress(id, address);
}

class DeleteAddressUseCase {
  final UserAddressRepository repository;
  DeleteAddressUseCase(this.repository);
  Future<void> call(int id) => repository.deleteAddress(id);
}

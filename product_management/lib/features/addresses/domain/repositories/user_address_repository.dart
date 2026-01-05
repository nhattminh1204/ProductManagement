import '../entities/user_address_entity.dart';

abstract class UserAddressRepository {
  Future<List<UserAddress>> getUserAddresses(int userId);
  Future<UserAddress> createAddress(UserAddress address);
  Future<UserAddress> updateAddress(int id, UserAddress address);
  Future<void> deleteAddress(int id);
}

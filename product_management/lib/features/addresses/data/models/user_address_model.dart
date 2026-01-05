import '../../domain/entities/user_address_entity.dart';

class UserAddressModel extends UserAddress {
  UserAddressModel({
    required super.id,
    required super.userId,
    required super.recipientName,
    required super.phone,
    required super.address,
    super.city,
    super.isDefault,
  });

  factory UserAddressModel.fromJson(Map<String, dynamic> json) {
    return UserAddressModel(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      recipientName: json['recipientName'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      city: json['city'],
      isDefault: json['isDefault'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'recipientName': recipientName,
      'phone': phone,
      'address': address,
      'city': city,
      'isDefault': isDefault,
    };
  }
}

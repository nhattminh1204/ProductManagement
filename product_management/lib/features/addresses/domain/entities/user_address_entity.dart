class UserAddress {
  final int id;
  final int userId;
  final String recipientName;
  final String phone;
  final String address;
  final String? city;
  final bool isDefault;

  UserAddress({
    required this.id,
    required this.userId,
    required this.recipientName,
    required this.phone,
    required this.address,
    this.city,
    this.isDefault = false,
  });
}

class User {
  final int id;
  final String name;
  final String username;
  final String email;
  final String? phone;
  final String? address;
  final String role;
  final String status;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    this.phone,
    this.address,
    required this.role,
    required this.status,
  });
}



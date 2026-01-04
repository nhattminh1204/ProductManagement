class User {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String role; // user, admin
  final String status; // active, inactive

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.role,
    required this.status,
  });
}



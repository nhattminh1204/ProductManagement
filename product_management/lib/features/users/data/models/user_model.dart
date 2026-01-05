class UserModel {
  final int id;
  final String name;
  final String username;
  final String email;
  final String? phone;
  final String? address;
  final String? password; // Only used for sending updates/creation, usually null in responses
  final String role; // user, admin
  final String status; // active, inactive
  final DateTime? createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    this.phone,
    this.address,
    this.password,
    required this.role,
    required this.status,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      address: json['address'],
      role: json['role'] ?? 'user',
      status: json['status'] ?? 'active',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'phone': phone,
      'address': address,
      'role': role,
      'status': status,
    };
    if (password != null && password!.isNotEmpty) {
      data['password'] = password;
    }
    return data;
  }
}



import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../api/api_service.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import 'package:product_management/product_management/presentation/design_system.dart';
import '../../data/models/user_model.dart';
import 'package:intl/intl.dart';
import 'change_password_screen.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  bool _isLoading = false;
  UserModel? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);
    final userId = context.read<AuthProvider>().userId;
    if (userId != null) {
      try {
        final user = await ApiService().getUserById(userId);
        _currentUser = user;
        _nameController.text = user.name;
        _usernameController.text = user.username;
        _emailController.text = user.email;
        _phoneController.text = user.phone ?? '';
        _addressController.text = user.address ?? '';
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Failed to load profile: $e')));
        }
      }
    }
    setState(() => _isLoading = false);
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate() || _currentUser == null) return;

    setState(() => _isLoading = true);
    try {
      final updatedUser = UserModel(
        id: _currentUser!.id,
        name: _nameController.text.trim(),
        username: _usernameController.text.trim(),
        email: _currentUser!.email, // Keep using original email for safety
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
        password: '',
        role: _currentUser!.role,
        status: _currentUser!.status,
      );

      await ApiService().updateUser(_currentUser!.id, updatedUser);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cập nhật hồ sơ thành công')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Cập nhật thất bại: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Chỉnh sửa hồ sơ'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: _isLoading && _currentUser == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 1. Avatar Section
                    Hero(
                      tag: 'profile_avatar',
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary.withOpacity(0.1),
                          border: Border.all(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          _currentUser?.name.isNotEmpty == true
                              ? _currentUser!.name.substring(0, 1).toUpperCase()
                              : '?',
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _nameController.text.isNotEmpty
                          ? _nameController.text
                          : 'User',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (_currentUser?.createdAt != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'Member since ${DateFormat('MMMM yyyy').format(_currentUser!.createdAt!)}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                      ),
                    const SizedBox(height: 32),

                    // 2. Personal Information
                    _buildSectionHeader('Personal Information'),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _usernameController,
                      decoration: _buildInputDecoration(
                        'Tên đăng nhập',
                        Icons.alternate_email,
                      ),
                      validator: (v) => v == null || v.isEmpty
                          ? 'Tên đăng nhập là bắt buộc'
                          : null,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _emailController,
                      decoration: _buildInputDecoration(
                        'Email',
                        Icons.email_outlined,
                        isReadOnly: true,
                      ),
                      readOnly: true,
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _nameController,
                      decoration: _buildInputDecoration(
                        'Họ và tên',
                        Icons.person_outline,
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Họ tên là bắt buộc' : null,
                      onChanged: (value) => setState(() {}),
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _phoneController,
                      decoration: _buildInputDecoration(
                        'Số điện thoại',
                        Icons.phone_outlined,
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _addressController,
                      decoration: _buildInputDecoration(
                        'Địa chỉ',
                        Icons.location_on_outlined,
                      ),
                      maxLines: 3,
                    ),

                    const SizedBox(height: 24),

                    // Change Password Button
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChangePasswordScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.lock_reset),
                      label: const Text('Đổi mật khẩu'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: const BorderSide(color: AppColors.primary),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _saveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 2,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Lưu thay đổi',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey[800],
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(
    String label,
    IconData icon, {
    bool isReadOnly = false,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(
        icon,
        color: isReadOnly ? Colors.grey : AppColors.primary,
      ),
      filled: true,
      fillColor: isReadOnly ? Colors.grey[100] : Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isReadOnly ? Colors.grey : AppColors.primary,
          width: 2,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}

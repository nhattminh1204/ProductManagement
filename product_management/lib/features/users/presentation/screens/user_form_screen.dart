import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../../domain/entities/user_entity.dart';
import 'package:product_management/product_management/presentation/design_system.dart';

class UserFormScreen extends StatefulWidget {
  final User? user;

  const UserFormScreen({super.key, this.user});

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  String _role = 'user';
  String _status = 'active';

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _nameController.text = widget.user!.name;
      _emailController.text = widget.user!.email;
      _phoneController.text = widget.user!.phone ?? '';
      _role = widget.user!.role;
      _status = widget.user!.status;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<UserProvider>();
      final user = User(
        id: widget.user?.id ?? 0,
        name: _nameController.text.trim(),
        username: widget.user?.username ?? _emailController.text.trim().split('@')[0],
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
        role: _role,
        status: _status,
      );

      final success = await provider.updateUser(widget.user!.id, user);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cập nhật người dùng thành công'),
            backgroundColor: AppColors.secondary,
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sửa người dùng'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
             Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromRGBO(0, 0, 0, 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(color: Colors.grey.shade200),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                       children: [
                        Icon(Icons.person, color: AppColors.primary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Thông tin cá nhân',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Tên hiển thị',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        prefixIcon: const Icon(Icons.person_outline),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập tên';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        prefixIcon: const Icon(Icons.email_outlined),
                         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                       filled: true,
                       fillColor: Colors.grey[50],
                      ),
                      enabled: false,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: 'Số điện thoại',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        prefixIcon: const Icon(Icons.phone_outlined),
                         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                  ],
                ),
             ),
             const SizedBox(height: 16),

             Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromRGBO(0, 0, 0, 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(color: Colors.grey.shade200),
                ),
                padding: const EdgeInsets.all(16),
                 child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                       children: [
                        Icon(Icons.admin_panel_settings, color: AppColors.primary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Phân quyền & Trạng thái',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Role
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                               const Text(
                                  'Vai trò',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                ),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: double.infinity,
                                child: SegmentedButton<String>(
                                  segments: const [
                                    ButtonSegment(
                                      value: 'user',
                                      icon: Icon(Icons.person_outline, size: 18),
                                      label: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 4),
                                        child: Text('User', style: TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis),
                                      ),
                                    ),
                                    ButtonSegment(
                                      value: 'admin',
                                      icon: Icon(Icons.admin_panel_settings_outlined, size: 18),
                                      label: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 4),
                                        child: Text('Admin', style: TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis),
                                      ),
                                    ),
                                  ],
                                  selected: {_role},
                                  onSelectionChanged: (Set<String> newSelection) {
                                    setState(() {
                                      _role = newSelection.first;
                                    });
                                  },
                                  style: ButtonStyle(
                                    padding: WidgetStateProperty.all(EdgeInsets.zero),
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Status
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Trạng thái',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: double.infinity,
                                child: SegmentedButton<String>(
                                  segments: const [
                                    ButtonSegment(
                                      value: 'active',
                                      icon: Icon(Icons.check_circle_outline, size: 18),
                                      label: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 4),
                                        child: Text('Bật', style: TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis),
                                      ),
                                    ),
                                    ButtonSegment(
                                      value: 'inactive',
                                      icon: Icon(Icons.block_outlined, size: 18),
                                      label: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 4),
                                        child: Text('Tắt', style: TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis),
                                      ),
                                    ),
                                  ],
                                  selected: {_status},
                                  onSelectionChanged: (Set<String> newSelection) {
                                    setState(() {
                                      _status = newSelection.first;
                                    });
                                  },
                                  style: ButtonStyle(
                                     padding: WidgetStateProperty.all(EdgeInsets.zero),
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                 ),
             ),
             
              const SizedBox(height: 24),
              Consumer<UserProvider>(
                builder: (context, provider, _) {
                  return SizedBox(
                     height: 50,
                     child: FilledButton(
                      onPressed: provider.isLoading ? null : _handleSubmit,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: provider.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Text(
                              'Cập nhật thông tin',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

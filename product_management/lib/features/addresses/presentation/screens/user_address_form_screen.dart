import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/user_address_entity.dart';
import '../providers/user_address_provider.dart';
import 'package:product_management/product_management/presentation/design_system.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class UserAddressFormScreen extends StatefulWidget {
  final UserAddress? address; // If null, create new

  const UserAddressFormScreen({super.key, this.address});

  @override
  State<UserAddressFormScreen> createState() => _UserAddressFormScreenState();
}

class _UserAddressFormScreenState extends State<UserAddressFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _recipientController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  bool _isDefault = false;

  @override
  void initState() {
    super.initState();
    if (widget.address != null) {
      _recipientController.text = widget.address!.recipientName;
      _phoneController.text = widget.address!.phone;
      _addressController.text = widget.address!.address;
      _cityController.text = widget.address!.city ?? '';
      _isDefault = widget.address!.isDefault;
    }
  }

  @override
  void dispose() {
    _recipientController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final userId = context.read<AuthProvider>().userId;
      if (userId == null) return;

      final newAddress = UserAddress(
        id: widget.address?.id ?? 0,
        userId: userId,
        recipientName: _recipientController.text.trim(),
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
        city: _cityController.text.trim().isEmpty ? null : _cityController.text.trim(),
        isDefault: _isDefault,
      );

      final provider = context.read<UserAddressProvider>();
      bool success;
      if (widget.address == null) {
        success = await provider.createAddress(newAddress);
      } else {
        success = await provider.updateAddress(newAddress.id, newAddress);
      }

      if (success && mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.address == null ? 'Thêm địa chỉ thành công' : 'Cập nhật địa chỉ thành công'),
            backgroundColor: AppColors.secondary,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.address == null ? 'Thêm địa chỉ mới' : 'Cập nhật địa chỉ'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _recipientController,
                decoration: const InputDecoration(labelText: 'Tên người nhận *'),
                validator: (v) => v == null || v.isEmpty ? 'Vui lòng nhập tên' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Số điện thoại *'),
                keyboardType: TextInputType.phone,
                validator: (v) => v == null || v.isEmpty ? 'Vui lòng nhập số điện thoại' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(labelText: 'Thành phố / Tỉnh'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Địa chỉ chi tiết (Số nhà, đường, phường/xã) *'),
                maxLines: 2,
                validator: (v) => v == null || v.isEmpty ? 'Vui lòng nhập địa chỉ' : null,
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Đặt làm địa chỉ mặc định'),
                value: _isDefault,
                onChanged: (v) => setState(() => _isDefault = v),
                activeColor: AppColors.primary,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: context.watch<UserAddressProvider>().isLoading ? null : _submit,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: context.watch<UserAddressProvider>().isLoading
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator())
                      : Text(widget.address == null ? 'Lưu địa chỉ' : 'Cập nhật'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

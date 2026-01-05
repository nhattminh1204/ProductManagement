import 'package:flutter/material.dart';
import 'package:product_management/features/shared/design_system.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/product_entity.dart';
import '../providers/product_provider.dart';
import '../../../categories/presentation/providers/category_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/screens/login_screen.dart';

class ProductFormScreen extends StatefulWidget {
  final Product? product; // null = Add, !null = Edit

  const ProductFormScreen({super.key, this.product});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _imageController;
  late TextEditingController _priceController;
  late TextEditingController _quantityController;
  bool _isActive = true;
  int? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _nameController = TextEditingController(text: p?.name ?? '');
    _imageController = TextEditingController(text: p?.image ?? '');
    _priceController = TextEditingController(text: p?.price.toString() ?? '');
    _quantityController = TextEditingController(
      text: p?.quantity.toString() ?? '',
    );
    _isActive = p?.status == 'active' ? true : (p == null ? true : false);
    _selectedCategoryId = p?.categoryId;

    // Load categories for dropdown
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      if (!authProvider.isAdmin) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Từ chối truy cập: Yêu cầu quyền Admin.'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      } else {
        context.read<CategoryProvider>().fetchActiveCategories();
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _imageController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedCategoryId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng chọn danh mục')),
        );
        return;
      }

      final newProduct = Product(
        id: widget.product?.id ?? 0,
        name: _nameController.text,
        image: _imageController.text.isEmpty ? null : _imageController.text,
        price: double.tryParse(_priceController.text) ?? 0,
        quantity: int.tryParse(_quantityController.text) ?? 0,
        status: _isActive ? 'active' : 'inactive',
        categoryId: _selectedCategoryId!,
      );

      final provider = context.read<ProductProvider>();
      bool success;
      if (widget.product == null) {
        success = await provider.createProduct(newProduct);
      } else {
        success = await provider.updateProduct(widget.product!.id, newProduct);
      }

      if (success && mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.product == null
                  ? 'Thêm thành công'
                  : 'Cập nhật thành công',
            ),
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(provider.errorMessage ?? 'Thao tác thất bại')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.product != null;
    final categoryProvider = context.watch<CategoryProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Sửa sản phẩm' : 'Thêm sản phẩm'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Tên sản phẩm'),
                validator: (val) => val!.isEmpty ? 'Nhập tên' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _imageController,
                decoration: const InputDecoration(labelText: 'URL Hình ảnh'),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(labelText: 'Giá'),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (val) => val!.isEmpty ? 'Nhập giá' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _quantityController,
                      decoration: const InputDecoration(labelText: 'Số lượng'),
                      keyboardType: TextInputType.number,
                      validator: (val) =>
                          val!.isEmpty ? 'Nhập số lượng' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                initialValue: _selectedCategoryId,
                decoration: const InputDecoration(labelText: 'Danh mục'),
                items: categoryProvider.categories.map((c) {
                  return DropdownMenuItem(value: c.id, child: Text(c.name));
                }).toList(),
                onChanged: (val) => setState(() => _selectedCategoryId = val),
                 hint: categoryProvider.isLoading
                    ? const Text('Đang tải danh mục...')
                    : const Text('Chọn danh mục'),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Trạng thái hoạt động'),
                value: _isActive,
                onChanged: (val) => setState(() => _isActive = val),
              ),
              const SizedBox(height: 30),
              Consumer<ProductProvider>(
                builder: (context, provider, _) {
                  return ElevatedButton(
                    onPressed: provider.isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(
                      isEditing ? 'Cập nhật' : 'Tạo mới',
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

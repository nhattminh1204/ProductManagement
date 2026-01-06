import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../api/api_service.dart';
import '../../../../core/utils/price_formatter.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import 'package:product_management/product_management/presentation/design_system.dart';
import 'checkout_success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  String _paymentMethod = 'cash';

  @override
  void initState() {
    super.initState();
    final authProvider = context.read<AuthProvider>();
    _emailController = TextEditingController(text: authProvider.userEmail ?? '');
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userId = context.read<AuthProvider>().userId;
    if (userId != null) {
      try {
        final user = await ApiService().getUserById(userId);
        if (mounted) {
          setState(() {
            if (_nameController.text.isEmpty) _nameController.text = user.name;
            if (_phoneController.text.isEmpty && user.phone != null) {
              _phoneController.text = user.phone!;
            }
            if (_addressController.text.isEmpty && user.address != null) {
              _addressController.text = user.address!;
            }
            // Also ensure email is synced if not already set or different
            if (_emailController.text.isEmpty) _emailController.text = user.email;
          });
        }
      } catch (e) {
        // debugPrint('Failed to load user data: $e');
        // Fail silently as we can still proceed with empty fields
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final cartProvider = context.read<CartProvider>();
      final orderProvider = context.read<OrderProvider>();
      
      if (cartProvider.items.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Giỏ hàng trống')),
        );
        return;
      }

      final userId = context.read<AuthProvider>().userId;

      final success = await orderProvider.createOrder(
        userId: userId,
        customerName: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        address: _addressController.text,
        paymentMethod: _paymentMethod,
        cartItems: cartProvider.items,
      );

      if (success && mounted) {
        cartProvider.clearCart();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const CheckoutSuccessScreen()),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text(orderProvider.errorMessage ?? 'Đặt hàng thất bại')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final orderProvider = context.watch<OrderProvider>();
    
    final subtotal = cartProvider.totalAmount;
    final shipping = subtotal > 500 ? 0.0 : 20.0;
    final total = subtotal + shipping;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Thanh toán'),
        centerTitle: true,
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
              _buildSectionTitle('Thông tin liên hệ'),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Họ và tên',
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                validator: (val) => val == null || val.length < 2 ? 'Nhập tên hợp lệ' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (val) => val == null || !val.contains('@') ? 'Nhập email hợp lệ' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Số điện thoại',
                  prefixIcon: const Icon(Icons.phone_outlined),
                  hintText: '09xxxxxxxx',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                keyboardType: TextInputType.phone,
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Nhập số điện thoại';
                  if (!RegExp(r'^(0\d{9,10})$').hasMatch(val)) return 'Số điện thoại không hợp lệ (0xxxxxxxxx)';
                  return null;
                },
              ),

              const SizedBox(height: 24),
              
              _buildSectionTitle('Địa chỉ giao hàng'),
              const SizedBox(height: 12),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Địa chỉ',
                  prefixIcon: const Icon(Icons.location_on_outlined),
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                maxLines: 3,
                validator: (val) => val == null || val.length < 10 ? 'Nhập địa chỉ hợp lệ (tối thiểu 10 ký tự)' : null,
              ),

              const SizedBox(height: 24),

              _buildSectionTitle('Phương thức thanh toán'),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _paymentMethod,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    items: const [
                       DropdownMenuItem(value: 'cash', child: Row(
                         children: [
                           Icon(Icons.money, color: Colors.green),
                           SizedBox(width: 12),
                           Text('Thanh toán khi nhận hàng (COD)'),
                         ],
                       )),
                       DropdownMenuItem(value: 'bank_transfer', child: Row(
                         children: [
                           Icon(Icons.account_balance, color: Colors.blue),
                           SizedBox(width: 12),
                           Text('Chuyển khoản ngân hàng (QR)'),
                         ],
                       )),
                       DropdownMenuItem(value: 'e_wallet', child: Row(
                         children: [
                           Icon(Icons.account_balance_wallet, color: Colors.purple),
                           SizedBox(width: 12),
                           Text('Ví điện tử (Momo/ZaloPay)'),
                         ],
                       )),
                       DropdownMenuItem(value: 'credit_card', child: Row(
                         children: [
                           Icon(Icons.credit_card, color: Colors.orange),
                           SizedBox(width: 12),
                           Text('Thẻ tín dụng/Ghi nợ'),
                         ],
                       )),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _paymentMethod = val);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 24),

              _buildSectionTitle('Thông tin đơn hàng'),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    ...cartProvider.items.map((item) => ListTile(
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                          image: item.product.image != null && item.product.image!.isNotEmpty
                           ? DecorationImage(
                               image: NetworkImage(item.product.image!),
                               fit: BoxFit.cover,
                             )
                           : null,
                        ),
                      ),
                      title: Text(item.product.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: Text('${item.quantity} x ${item.product.price.formatPriceWithCurrency()}'),
                      trailing: Text(item.totalPrice.formatPriceWithCurrency()),
                    )),
                    const Divider(),
                    Padding(
                       padding: const EdgeInsets.all(16),
                       child: Column(
                         children: [
                           _buildSummaryRow('Tạm tính', subtotal),
                           const SizedBox(height: 8),
                           _buildSummaryRow('Phí vận chuyển', shipping),
                           const Divider(height: 24),
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               const Text('Tổng cộng', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                               Text(total.formatPriceWithCurrency(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primary)),
                             ],
                           )
                         ],
                       ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: orderProvider.isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: orderProvider.isLoading
                   ? const CircularProgressIndicator(color: Colors.white)
                   : const Text('Đặt hàng', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.textMain,
      ),
    );
  }

  Widget _buildSummaryRow(String label, double value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600])),
        Text(value.formatPriceWithCurrency(), style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}



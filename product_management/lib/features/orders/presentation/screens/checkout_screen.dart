import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/price_formatter.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../shared/design_system.dart';
import 'user_order_history_screen.dart';

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
          const SnackBar(content: Text('Cart is empty')),
        );
        return;
      }

      final success = await orderProvider.createOrder(
        customerName: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        address: _addressController.text,
        paymentMethod: _paymentMethod,
        cartItems: cartProvider.items,
      );

      if (success && mounted) {
        cartProvider.clearCart();
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            title: const Text('Order Placed!'),
            content: const Text('Your order has been placed successfully.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const UserOrderHistoryScreen()),
                  );
                },
                child: const Text('View Orders'),
              ),
              TextButton(
                 onPressed: () {
                   Navigator.pop(ctx);
                   Navigator.popUntil(context, (route) => route.isFirst);
                 },
                 child: const Text('Home'),
              )
            ],
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text(orderProvider.errorMessage ?? 'Failed to place order')),
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
      appBar: AppBar(title: const Text('Checkout')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSectionTitle('Contact Information'),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (val) => val == null || val.length < 2 ? 'Enter valid name' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (val) => val == null || !val.contains('@') ? 'Enter valid email' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone_outlined),
                  hintText: '09xxxxxxxx',
                ),
                keyboardType: TextInputType.phone,
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Enter phone number';
                  if (!RegExp(r'^(0\d{9,10})$').hasMatch(val)) return 'Invalid phone format (0xxxxxxxxx)';
                  return null;
                },
              ),

              const SizedBox(height: 24),
              
              _buildSectionTitle('Shipping Address'),
              const SizedBox(height: 12),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  prefixIcon: Icon(Icons.location_on_outlined),
                  alignLabelWithHint: true,
                ),
                maxLines: 3,
                validator: (val) => val == null || val.length < 10 ? 'Enter valid address (min 10 chars)' : null,
              ),

              const SizedBox(height: 24),

              _buildSectionTitle('Payment Method'),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _paymentMethod,
                    isExpanded: true,
                    items: const [
                       DropdownMenuItem(value: 'cash', child: Text('Cash on Delivery')),
                       DropdownMenuItem(value: 'credit_card', child: Text('Credit Card')),
                       DropdownMenuItem(value: 'bank_transfer', child: Text('Bank Transfer')),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _paymentMethod = val);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 24),

              _buildSectionTitle('Order Summary'),
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
                           _buildSummaryRow('Subtotal', subtotal),
                           const SizedBox(height: 8),
                           _buildSummaryRow('Shipping', shipping),
                           const Divider(height: 24),
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               const Text('Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
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
                   : const Text('Place Order', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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



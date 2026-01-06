import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/price_formatter.dart';
import '../providers/cart_provider.dart';
import 'package:product_management/product_management/presentation/design_system.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  final VoidCallback? onGoShopping;

  const CartScreen({super.key, this.onGoShopping});

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Giỏ hàng'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else if (onGoShopping != null) {
              onGoShopping!();
            }
          },
        ),
        actions: [
          if (cartProvider.items.isNotEmpty)
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Xóa giỏ hàng'),
                    content: const Text(
                        'Bạn có chắc chắn muốn xóa tất cả sản phẩm khỏi giỏ hàng?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                        },
                        child: const Text('Hủy'),
                      ),
                      TextButton(
                        onPressed: () {
                          context.read<CartProvider>().clearCart();
                          Navigator.pop(ctx);
                        },
                        child: const Text('Xóa',
                            style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.delete_sweep_outlined, color: Colors.white),
            ),
        ],
      ),
      body: cartProvider.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[300]),
                   const SizedBox(height: 16),
                   Text('Giỏ hàng trống', style: TextStyle(fontSize: 18, color: Colors.grey[600])),
                   const SizedBox(height: 8),
                   ElevatedButton(
                     onPressed: () {
                       if (onGoShopping != null) {
                         onGoShopping!();
                       } else if (Navigator.canPop(context)) {
                         Navigator.pop(context);
                       } else {
                         // Default fallback if we can't pop and no callback provided
                         // You might want to navigate to a specific route here
                         Navigator.of(context).popUntil((route) => route.isFirst);
                       }
                     }, 
                     child: const Text('Mua sắm ngay'),
                   )
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: cartProvider.items.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final item = cartProvider.items[index];
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Image
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.grey[100],
                                image: item.product.image != null && item.product.image!.isNotEmpty
                                    ? DecorationImage(
                                        image: NetworkImage(item.product.image!),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: item.product.image == null || item.product.image!.isEmpty
                                  ? const Icon(Icons.image_not_supported, color: Colors.grey)
                                  : null,
                            ),
                            const SizedBox(width: 16),
                            // Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.product.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: AppColors.textMain,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.product.price.formatPriceWithCurrency(),
                                    style: const TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // Quantity Controls
                                  Row(
                                    children: [
                                      _QuantityButton(
                                        icon: Icons.remove,
                                        onTap: () {
                                          cartProvider.updateQuantity(item.product.id, item.quantity - 1);
                                        },
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        '${item.quantity}',
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                      ),
                                      const SizedBox(width: 12),
                                      _QuantityButton(
                                        icon: Icons.add,
                                        onTap: () {
                                          cartProvider.updateQuantity(item.product.id, item.quantity + 1);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Remove Button
                            IconButton(
                              onPressed: () {
                                cartProvider.removeFromCart(item.product.id);
                              },
                              icon: const Icon(Icons.delete_outline, color: Colors.red),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                // Bottom Section
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 20,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Tổng tiền',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              cartProvider.totalAmount.formatPriceWithCurrency(),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textMain,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const CheckoutScreen()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Thanh toán',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QuantityButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: Colors.grey[700]),
      ),
    );
  }
}


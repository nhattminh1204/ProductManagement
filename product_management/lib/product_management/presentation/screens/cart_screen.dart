import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../../../core/utils/price_formatter.dart';
import '../providers/cart_provider.dart';
import '../design_system.dart';
import 'checkout_screen.dart';
import 'user_main_screen.dart';

class CartScreen extends StatelessWidget {
  final VoidCallback? onGoShopping;

  const CartScreen({super.key, this.onGoShopping});

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        elevation: 0,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        leading: onGoShopping != null
            ? IconButton(
                icon: const Icon(Icons.menu_rounded, color: Colors.white),
                onPressed: () => Scaffold.of(context).openDrawer(),
              )
            : null, // Show default back button if pushed (onGoShopping is null)
        // Or if it is a tab, handle differently. But assuming it's pushed from Detail or Main:
        // If pushed, it has a back button automatically. If it's a tab in UserMainScreen, it needs a different approach.
        // However, the error comes from `Scaffold.of(context).openDrawer()` where `context` is the one from CartScreen build method.
        // And Scaffold is IN CartScreen, not above it (unless UserMainScreen wraps it, but the context here is CartScreen's).
        // To fix: remove manual drawer button if not needed (it usually has back button if pushed).
        // If it is meant to be a top level screen with drawer, it needs to be used inside a layout that provides Scaffold or use a Builder.
        // BUT, based on UserMainScreen, CartScreen is one of the tabs. UserMainScreen HAS the Scaffold and Drawer.
        // CartScreen is a child of UserMainScreen's body (IndexedStack).
        // So `Scaffold.of(context)` SHOULD find UserMainScreen's Scaffold.
        // WAIT. CartScreen defines its OWN Scaffold at line 15.
        // Nested Scaffolds. `Scaffold.of(context)` inside `build` uses the context of `CartScreen` widget.
        // It looks UP correctly. But `CartScreen` returns a `Scaffold`.
        // So `Scaffold.of(context)` looks ABOVE `CartScreen`.
        // If `CartScreen` is inside `UserMainScreen`'s body: `Scaffold.of(context)` finds `UserMainScreen`'s Scaffold.
        // That should work.
        // UNLESS... CartScreen is pushed via Navigator.push(CartScreen). Then there is NO parent Scaffold.
        // If pushed: Back button is shown automatically. Drawer shouldn't be accessible unless we want it.
        // If tab: It is inside UserMainScreen.

        // The error suggests we are trying to open drawer but maybe we are not where we think we are.
        // Or we are calling it in a context that doesn't have it.
        // Let's safe guard it or just remove the drawer button if it's confusing.
        // Usually Cart page should have a strictly "Back" or nothing.

        // Let's remove the leading IconButton which tries to open Drawer.
        // If user wants to go back, standard BackButton will appear automatically if pushed.
        // If it's a tab, we don't usually put a hamburger menu on inner tabs unless it's the main root.

        // Re: "Go Shopping" navigation.
        // If it's pushed, we can pop.
        // If it's a tab, we might want to switch tab index.

        // Let's fix the "Go Shopping" to just pop if we can, or go to root.
      ),
      body: cartProvider.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Your cart is empty',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (onGoShopping != null) {
                        onGoShopping!();
                      } else if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      } else {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => const UserMainScreen(),
                          ),
                        );
                      }
                    },
                    child: const Text('Go Shopping'),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: cartProvider.items.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
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
                                image:
                                    item.product.image != null &&
                                        item.product.image!.isNotEmpty
                                    ? DecorationImage(
                                        image: NetworkImage(
                                          item.product.image!,
                                        ),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child:
                                  item.product.image == null ||
                                      item.product.image!.isEmpty
                                  ? const Icon(
                                      Icons.image_not_supported,
                                      color: Colors.grey,
                                    )
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
                                    item.product.price
                                        .formatPriceWithCurrency(),
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
                                          cartProvider.updateQuantity(
                                            item.product.id,
                                            item.quantity - 1,
                                          );
                                        },
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        '${item.quantity}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      _QuantityButton(
                                        icon: Icons.add,
                                        onTap: () {
                                          cartProvider.updateQuantity(
                                            item.product.id,
                                            item.quantity + 1,
                                          );
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
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
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
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
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
                              'Total Amount',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              cartProvider.totalAmount
                                  .formatPriceWithCurrency(),
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
                                MaterialPageRoute(
                                  builder: (_) => const CheckoutScreen(),
                                ),
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
                              'Checkout',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
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

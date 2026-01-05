import 'package:flutter/material.dart';
import 'package:product_management/features/orders/presentation/providers/cart_provider.dart';
import 'package:product_management/features/orders/presentation/screens/cart_screen.dart';
import 'package:product_management/features/products/domain/entities/product_entity.dart';
import 'package:provider/provider.dart';
import '../../../shared/widgets/add_to_cart_animation.dart';
import '../../../orders/presentation/providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../shared/design_system.dart';
import '../../../products/presentation/screens/product_detail_screen.dart';
import '../../../../core/utils/price_formatter.dart';

class WishlistScreen extends StatefulWidget {
  final VoidCallback? onGoHome;

  const WishlistScreen({super.key, this.onGoHome});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  final GlobalKey _cartKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<AuthProvider>().userId;
      if (userId != null) {
        context.read<WishlistProvider>().fetchWishlist(userId);
      }
    });
  }

  void _handleAddToCart(GlobalKey imageKey, Product product) {
    if (product.image != null && product.image!.isNotEmpty) {
      AddToCartAnimation.run(
        context,
        imageKey: imageKey,
        cartKey: _cartKey,
        imageUrl: product.image!,
        onComplete: () {
          _addToCart(product);
        },
      );
    } else {
      _addToCart(product);
    }
  }

  void _addToCart(Product product) async {
    await context.read<CartProvider>().addToCart(product);
  }

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = context.watch<WishlistProvider>();
    final userId = context.watch<AuthProvider>().userId;
    final cartProvider = context.watch<CartProvider>();

    if (userId == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Danh sách yêu thích'),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: widget.onGoHome ?? () => Navigator.of(context).pop(),
          ),
        ),
        body: const Center(child: Text('Vui lòng đăng nhập để xem danh sách yêu thích')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Danh sách yêu thích'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onGoHome ?? () => Navigator.of(context).pop(),
        ),
      ),
      body: wishlistProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : wishlistProvider.errorMessage != null
          ? Center(child: Text('Lỗi: ${wishlistProvider.errorMessage}'))
          : wishlistProvider.items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Danh sách yêu thích trống',
                    style: TextStyle(color: Colors.grey[600], fontSize: 18),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: wishlistProvider.items.length,
              itemBuilder: (context, index) {
                final item = wishlistProvider.items[index];
                final product = item.product;
                if (product == null) {
                  return ListTile(
                    title: Text(
                      'Product ID: ${item.productId} (Details missing)',
                    ),
                  );
                }
                return WishlistItem(
                  key: ValueKey(product.id),
                  product: product,
                  userId: userId,
                  onAddToCart: (key) => _handleAddToCart(key, product),
                );
              },
            ),
      floatingActionButton: Stack(
        clipBehavior: Clip.none,
        children: [
          FloatingActionButton(
            key: _cartKey,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      CartScreen(onGoShopping: () => Navigator.pop(context)),
                ),
              );
            },
            backgroundColor: AppColors.primary,
            child: const Icon(Icons.shopping_cart_rounded, color: Colors.white),
          ),
          if (cartProvider.getItemCount > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(
                  minWidth: 20,
                  minHeight: 20,
                ),
                child: Center(
                  child: Text(
                    '${cartProvider.getItemCount}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class WishlistItem extends StatefulWidget {
  final Product product;
  final int userId;
  final Function(GlobalKey) onAddToCart;

  const WishlistItem({
    super.key,
    required this.product,
    required this.userId,
    required this.onAddToCart,
  });

  @override
  State<WishlistItem> createState() => _WishlistItemState();
}

class _WishlistItemState extends State<WishlistItem> {
  final GlobalKey _imageKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductDetailScreen(product: widget.product),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Image
              Container(
                key: _imageKey,
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[100],
                  image:
                      widget.product.image != null &&
                          widget.product.image!.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(widget.product.image!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child:
                    widget.product.image == null ||
                        widget.product.image!.isEmpty
                    ? const Icon(Icons.image_not_supported, color: Colors.grey)
                    : null,
              ),
              const SizedBox(width: 16),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.product.price.formatPriceWithCurrency(),
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              // Actions
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.red),
                    onPressed: () {
                      context.read<WishlistProvider>().removeFromWishlist(
                        widget.userId,
                        widget.product.id,
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.shopping_cart_outlined,
                      color: AppColors.primary,
                    ),
                    onPressed: () => widget.onAddToCart(_imageKey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

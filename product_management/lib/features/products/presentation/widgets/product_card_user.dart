import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/product_entity.dart';
import '../../../../core/utils/price_formatter.dart';
import '../../../orders/presentation/providers/cart_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../wishlist/presentation/providers/wishlist_provider.dart';
import '../../../shared/design_system.dart';
import '../../../shared/widgets/love_button.dart';
import '../screens/product_detail_screen.dart';

class ProductCardUser extends StatefulWidget {
  final Product product;
  final Function(GlobalKey)? onAddToCart;

  const ProductCardUser({
    super.key,
    required this.product,
    this.onAddToCart,
  });

  @override
  State<ProductCardUser> createState() => _ProductCardUserState();
}

class _ProductCardUserState extends State<ProductCardUser> {
  final GlobalKey _imageKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ProductDetailScreen(product: widget.product)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Section
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      child: Container(
                        key: _imageKey,
                        child: widget.product.image != null && widget.product.image!.isNotEmpty
                            ? Image.network(
                                widget.product.image!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    color: Colors.grey[100],
                                    child: Center(
                                      child: Icon(Icons.image_not_supported_rounded,
                                          color: Colors.grey[300], size: 40),
                                    ),
                                  );
                                },
                              )
                            : Container(
                                width: double.infinity,
                                height: double.infinity,
                                color: Colors.grey[100],
                                child: Center(
                                  child: Icon(Icons.inventory_2_rounded,
                                      color: Colors.grey[300], size: 40),
                                ),
                              ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Consumer2<WishlistProvider, AuthProvider>(
                      builder: (context, wishlistProvider, authProvider, child) {
                        final isWishlisted = wishlistProvider.isInWishlist(widget.product.id);
                        return Container(
                          height: 32,
                          width: 32,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              )
                            ],
                          ),
                          child: Center(
                            child: LoveButton(
                              isLiked: isWishlisted,
                              size: 18,
                              onTap: () async {
                                if (!authProvider.isAuthenticated || authProvider.userId == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text(
                                          'Vui lòng đăng nhập để thêm vào danh sách yêu thích'),
                                      backgroundColor: AppColors.error,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10)),
                                      width: 300,
                                    ),
                                  );
                                  return;
                                }

                                try {
                                  if (isWishlisted) {
                                    await wishlistProvider.removeFromWishlist(
                                        authProvider.userId!, widget.product.id);
                                  } else {
                                    await wishlistProvider.addToWishlist(
                                        authProvider.userId!, widget.product.id);
                                  }
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Lỗi: ${e.toString()}'),
                                      backgroundColor: AppColors.error,
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Content Section - Fixed height
            Container(
              height: 110,
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: AppColors.textMain,
                        height: 1.1,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Rating Row - Always reserve space (fixed height)
                  SizedBox(
                    height: 16,
                    child: widget.product.averageRating != null && widget.product.averageRating! > 0
                        ? Row(
                            children: [
                              const Icon(Icons.star_rounded,
                                  color: Colors.amber, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                widget.product.averageRating!.toStringAsFixed(1),
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '(${widget.product.totalRatings ?? 0})',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[400],
                                ),
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              Icon(Icons.star_outline_rounded,
                                  color: Colors.grey[300], size: 14),
                              const SizedBox(width: 4),
                              Text(
                                'Chưa có đánh giá',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[400],
                                ),
                              ),
                            ],
                          ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.product.price.formatPriceWithCurrency(),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            )
                          ],
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.shopping_cart_outlined,
                              size: 16, color: Colors.white),
                          onPressed: () {
                            if (widget.onAddToCart != null) {
                              widget.onAddToCart!(_imageKey);
                            } else {
                              context.read<CartProvider>().addToCart(widget.product);
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${widget.product.name} added to cart'),
                                  backgroundColor: AppColors.textMain,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  width: 200,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

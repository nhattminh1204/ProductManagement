import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animations/animations.dart';
import '../../domain/entities/product_entity.dart';
import '../../../../core/utils/price_formatter.dart';
import '../../../orders/presentation/providers/cart_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../wishlist/presentation/providers/wishlist_provider.dart';
import 'package:product_management/product_management/presentation/design_system.dart';
import '../screens/product_detail_screen.dart';

class ProductCardUser extends StatefulWidget {
  final Product product;
  final Function(GlobalKey)? onAddToCart;

  const ProductCardUser({super.key, required this.product, this.onAddToCart});

  @override
  State<ProductCardUser> createState() => _ProductCardUserState();
}

class _ProductCardUserState extends State<ProductCardUser> {
  final GlobalKey _imageKey = GlobalKey();
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      closedElevation: 0,
      openElevation: 0,
      closedColor: Colors.transparent,
      openColor: AppColors.background,
      transitionDuration: const Duration(milliseconds: 500),
      openBuilder: (context, _) => ProductDetailScreen(product: widget.product),
      closedBuilder: (context, openContainer) {
        return MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: GestureDetector(
            onTap: openContainer,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppDimensions.radius),
                border: Border.all(
                  color: _isHovered
                      ? AppColors.primary.withValues(alpha: 0.5)
                      : AppColors.border,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Image Section (70% height implied by flex)
                  Expanded(
                    flex: 7,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(AppDimensions.radius - 1),
                          ),
                          child: Container(
                            key: _imageKey,
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(AppDimensions.radius - 1),
                              ),
                            ),
                            child: Hero(
                              tag: 'product_image_${widget.product.id}',
                              child: widget.product.image != null &&
                                      widget.product.image!.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.network(
                                        widget.product.image!,
                                        fit: BoxFit.contain,
                                        width: double.infinity,
                                        height: double.infinity,
                                        errorBuilder: (context, error, stackTrace) {
                                          return const Center(
                                            child: Icon(
                                              Icons.image_not_supported_rounded,
                                              color: AppColors.textLight,
                                              size: 40,
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  : const Center(
                                      child: Icon(
                                        Icons.inventory_2_rounded,
                                        color: AppColors.textLight,
                                        size: 40,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        // Wishlist Button
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Consumer2<WishlistProvider, AuthProvider>(
                            builder:
                                (
                                  context,
                                  wishlistProvider,
                                  authProvider,
                                  child,
                                ) {
                                  final isWishlisted = wishlistProvider
                                      .isInWishlist(widget.product.id);
                                  return GestureDetector(
                                    onTap: () async {
                                      if (!authProvider.isAuthenticated ||
                                          authProvider.userId == null) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Please login to save products',
                                            ),
                                          ),
                                        );
                                        return;
                                      }
                                      if (isWishlisted) {
                                        await wishlistProvider
                                            .removeFromWishlist(
                                              authProvider.userId!,
                                              widget.product.id,
                                            );
                                      } else {
                                        // Trigger a small haptic feedback or visual effect here if possible
                                        await wishlistProvider.addToWishlist(
                                          authProvider.userId!,
                                          widget.product.id,
                                        );
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(
                                          alpha: 0.9,
                                        ),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(
                                              alpha: 0.05,
                                            ),
                                            blurRadius: 10,
                                          ),
                                        ],
                                      ),
                                      child: AnimatedSwitcher(
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        transitionBuilder:
                                            (
                                              Widget child,
                                              Animation<double> animation,
                                            ) {
                                              return ScaleTransition(
                                                scale: animation,
                                                child: child,
                                              );
                                            },
                                        child: Icon(
                                          isWishlisted
                                              ? Icons.favorite_rounded
                                              : Icons.favorite_border_rounded,
                                          key: ValueKey<bool>(isWishlisted),
                                          size: 18,
                                          color: isWishlisted
                                              ? AppColors.error
                                              : AppColors.textLight,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Info Section (Remaining 30%)
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(AppDimensions.paddingSmall),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.product.name,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: AppColors.textMain,
                                      fontWeight: FontWeight.w600,
                                      height: 1.2,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star_rounded,
                                    size: 14,
                                    color:
                                        (widget.product.averageRating ?? 0) > 0
                                        ? const Color(0xFFFFB800)
                                        : AppColors.textLight.withValues(
                                            alpha: 0.5,
                                          ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    (widget.product.averageRating ?? 0) > 0
                                        ? widget.product.averageRating!
                                              .toStringAsFixed(1)
                                        : 'No rating',
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color:
                                              (widget.product.averageRating ??
                                                      0) >
                                                  0
                                              ? AppColors.textMain
                                              : AppColors.textLight,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                  if ((widget.product.averageRating ?? 0) > 0 &&
                                      widget.product.totalRatings != null) ...[
                                    const SizedBox(width: 4),
                                    Text(
                                      '(${widget.product.totalRatings})',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: AppColors.textLight,
                                            fontSize: 10,
                                          ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.product.price.formatPriceWithCurrency(),
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              // Add to Cart Button (Minimal)
                              InkWell(
                                onTap: () {
                                  if (widget.onAddToCart != null) {
                                    widget.onAddToCart!(_imageKey);
                                  } else {
                                    context.read<CartProvider>().addToCart(
                                      widget.product,
                                    );
                                  }
                                },
                                borderRadius: BorderRadius.circular(8),
                                splashColor: AppColors.primary.withValues(
                                  alpha: 0.3,
                                ),
                                highlightColor: AppColors.primary.withValues(
                                  alpha: 0.1,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons
                                        .add_shopping_cart_rounded, // Changed icon to verify visual update
                                    color: AppColors.primary,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

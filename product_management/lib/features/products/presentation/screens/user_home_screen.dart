import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/product_entity.dart';
import '../providers/product_provider.dart';
import '../../../categories/presentation/providers/category_provider.dart';
import '../../../orders/presentation/providers/cart_provider.dart';
import '../widgets/product_card_user.dart';
import 'package:product_management/product_management/presentation/design_system.dart';
import 'user_product_list_screen.dart';
import '../../../orders/presentation/screens/cart_screen.dart';
import '../../../shared/widgets/add_to_cart_animation.dart';

class UserHomeScreen extends StatefulWidget {
  final GlobalKey? cartKey;
  final VoidCallback? onOpenDrawer;

  const UserHomeScreen({super.key, this.cartKey, this.onOpenDrawer});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchProducts();
      context.read<ProductProvider>().fetchFeaturedProducts();
      context.read<CategoryProvider>().fetchActiveCategories();
    });
  }

  // Get top products by category (sorted by rating, top 10)
  List<Product> _getTopProductsByCategory(
    List<Product> allProducts,
    String categoryName,
  ) {
    final categoryProducts = allProducts
        .where((p) => p.categoryName == categoryName && p.status == 'active')
        .toList();

    // Sort by rating (descending), then by totalRatings
    categoryProducts.sort((a, b) {
      final ratingA = a.averageRating ?? 0.0;
      final ratingB = b.averageRating ?? 0.0;
      if (ratingA != ratingB) {
        return ratingB.compareTo(ratingA);
      }
      final totalA = a.totalRatings ?? 0;
      final totalB = b.totalRatings ?? 0;
      return totalB.compareTo(totalA);
    });

    // Return top 10
    return categoryProducts.take(10).toList();
  }

  // Removed unused _cartKey
  // final GlobalKey _cartKey = GlobalKey();

  void _handleAddToCart(GlobalKey imageKey, Product product) {
    if (product.image == null ||
        product.image!.isEmpty ||
        widget.cartKey == null) {
      _addToCart(product);
      return;
    }

    AddToCartAnimation.run(
      context,
      imageKey: imageKey,
      cartKey: widget.cartKey!,
      imageUrl: product.image!,
      onComplete: () {
        _addToCart(product);
      },
    );
  }

  Future<void> _addToCart(Product product) async {
    await context.read<CartProvider>().addToCart(product);
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final categoryProvider = context.watch<CategoryProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App Bar
          // App Bar
          SliverAppBar(
            pinned: true,
            floating: true,
            elevation: 0,
            backgroundColor: AppColors.primary,
            scrolledUnderElevation: 0,
            surfaceTintColor: Colors.transparent,
            leading: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: IconButton(
                icon: const Icon(Icons.menu_rounded, color: Colors.white),
                onPressed: () => widget.onOpenDrawer?.call(),
              ),
            ),
            // Search Pill
            title: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const UserProductListScreen(),
                  ),
                );
              },
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: AppColors.border, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.search_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Search products...',
                      style: GoogleFonts.inter(
                        color: AppColors.textLight,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            centerTitle: true,
            actions: [
              const SizedBox(width: 16), // Padding for alignment
            ],
          ),

          // Content
          if (categoryProvider.isLoading || productProvider.isLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (categoryProvider.errorMessage != null ||
              productProvider.errorMessage != null)
            SliverFillRemaining(
              child: Center(
                child: Text(
                  categoryProvider.errorMessage ??
                      productProvider.errorMessage ??
                      'Error loading data',
                ),
              ),
            )
          else if (categoryProvider.categories.isEmpty)
            const SliverFillRemaining(
              child: Center(child: Text('No categories found')),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  // Featured Products section at index 0
                  if (index == 0 &&
                      productProvider.featuredProducts.isNotEmpty) {
                    return _buildFeaturedSection(
                      productProvider.featuredProducts,
                    );
                  }

                  // Category sections (adjust index for featured section)
                  final categoryIndex =
                      productProvider.featuredProducts.isNotEmpty
                      ? index - 1
                      : index;

                  if (categoryIndex < 0 ||
                      categoryIndex >= categoryProvider.categories.length) {
                    return const SizedBox.shrink();
                  }

                  final category = categoryProvider.categories[categoryIndex];
                  final topProducts = _getTopProductsByCategory(
                    productProvider.products,
                    category.name,
                  );

                  if (topProducts.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return _buildCategorySection(category.name, topProducts);
                },
                childCount:
                    categoryProvider.categories.length +
                    (productProvider.featuredProducts.isNotEmpty ? 1 : 0),
              ),
            ),

          const SliverPadding(padding: EdgeInsets.only(bottom: 20)),
        ],
      ),
    );
  }

  Widget _buildFeaturedSection(List<Product> products) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Featured Products Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.star_rounded, color: Colors.amber, size: 24),
                  const SizedBox(width: 8),
                  const Text(
                    'Featured Products',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMain,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const UserProductListScreen(),
                    ),
                  );
                },
                child: const Text(
                  'View all',
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
            ],
          ),
        ),
        // Horizontal Product List
        SizedBox(
          height: 320,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: SizedBox(
                  width: 170,
                  child: ProductCardUser(
                    product: product,
                    onAddToCart: (key) async => _handleAddToCart(key, product),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildCategorySection(String categoryName, List<Product> products) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                categoryName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textMain,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const UserProductListScreen(),
                    ),
                  );
                },
                child: const Text(
                  'View all',
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
            ],
          ),
        ),
        // Horizontal Product List
        SizedBox(
          height: 320,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: SizedBox(
                  width: 170,
                  child: ProductCardUser(
                    product: product,
                    onAddToCart: (key) async => _handleAddToCart(key, product),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

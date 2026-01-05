import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/product_entity.dart';
import '../providers/product_provider.dart';
import '../../../categories/presentation/providers/category_provider.dart';
import '../../../orders/presentation/providers/cart_provider.dart';
import '../widgets/product_card_user.dart';
import '../../../shared/design_system.dart';
import 'user_product_list_screen.dart';
import '../../../orders/presentation/screens/cart_screen.dart';
import '../../../shared/widgets/add_to_cart_animation.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

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
  List<Product> _getTopProductsByCategory(List<Product> allProducts, String categoryName) {
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

  final GlobalKey _cartKey = GlobalKey();

  void _handleAddToCart(GlobalKey imageKey, Product product) {
     if (product.image == null || product.image!.isEmpty) {
        _addToCart(product);
        return;
     }

      AddToCartAnimation.run(
        context,
        imageKey: imageKey,
        cartKey: _cartKey,
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
          SliverAppBar(
            pinned: true,
            floating: false,
            elevation: 0,
            backgroundColor: AppColors.primary,
            scrolledUnderElevation: 0,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.menu_rounded, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
            title: Text(
              'Khám phá',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.search_rounded, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const UserProductListScreen()),
                  );
                },
              ),
              const SizedBox(width: 8),
            ],
          ),

          // Content
          if (categoryProvider.isLoading || productProvider.isLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (categoryProvider.errorMessage != null || productProvider.errorMessage != null)
            SliverFillRemaining(
              child: Center(
                child: Text(
                  categoryProvider.errorMessage ?? productProvider.errorMessage ?? 'Error loading data',
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
                  if (index == 0 && productProvider.featuredProducts.isNotEmpty) {
                    return _buildFeaturedSection(productProvider.featuredProducts);
                  }
                  
                  // Category sections (adjust index for featured section)
                  final categoryIndex = productProvider.featuredProducts.isNotEmpty 
                      ? index - 1 
                      : index;
                  
                  if (categoryIndex < 0 || categoryIndex >= categoryProvider.categories.length) {
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
                childCount: categoryProvider.categories.length + 
                    (productProvider.featuredProducts.isNotEmpty ? 1 : 0),
              ),
            ),
          
          const SliverPadding(padding: EdgeInsets.only(bottom: 20)),
        ],
      ),
      floatingActionButton: Consumer<CartProvider>(
        builder: (context, cartProvider, _) {
          return Stack(
            clipBehavior: Clip.none,
            children: [
              FloatingActionButton(
                key: _cartKey,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartScreen()),
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
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
                    'Sản phẩm nổi bật',
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
                  'Xem tất cả',
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
            ],
          ),
        ),
        // Horizontal Product List
        SizedBox(
          height: 280,
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
                  'Xem tất cả',
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
            ],
          ),
        ),
        // Horizontal Product List
        SizedBox(
          height: 280,
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



import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/entities.dart';
import '../providers/product_provider.dart';
import '../providers/category_provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/product_card_user.dart';
import '../widgets/skeleton_loader.dart';
import '../design_system.dart';
import 'user_product_list_screen.dart';
import 'cart_screen.dart';

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
            floating: true,
            pinned: true,
            elevation: 0,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            scrolledUnderElevation: 0,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.menu_rounded, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
            title: Text(
              'Discover',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            centerTitle: false,
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
             SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            SkeletonLoader(width: 150, height: 24), // Title
                            SkeletonLoader(width: 60, height: 20), // View All
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 280,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: 3, // Show 3 skeleton cards
                          itemBuilder: (context, index) {
                            return const ProductCardSkeleton();
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                },
                childCount: 3, // Show 3 skeleton sections
              ),
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
                  final category = categoryProvider.categories[index];
                  final topProducts = _getTopProductsByCategory(
                    productProvider.products,
                    category.name,
                  );

                  if (topProducts.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return _buildCategorySection(category.name, topProducts);
                },
                childCount: categoryProvider.categories.length,
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
                      builder: (_) => UserProductListScreen(initialCategory: categoryName),
                    ),
                  );
                },
                child: const Text(
                  'View All',
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
                  child: ProductCardUser(product: product),
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


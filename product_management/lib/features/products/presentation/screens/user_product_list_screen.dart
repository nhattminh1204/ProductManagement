import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../../../categories/presentation/providers/category_provider.dart';
import '../../../orders/presentation/providers/cart_provider.dart';
import '../widgets/product_card_user.dart';
import 'package:product_management/product_management/presentation/design_system.dart';
import '../../../orders/presentation/screens/cart_screen.dart';
import '../../../shared/widgets/add_to_cart_animation.dart';
import '../widgets/product_filter_sheet.dart';

class UserProductListScreen extends StatefulWidget {
  const UserProductListScreen({super.key});

  @override
  State<UserProductListScreen> createState() => _UserProductListScreenState();
}

class _UserProductListScreenState extends State<UserProductListScreen> {
  final _searchController = TextEditingController();
  int? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchProducts();
      context.read<CategoryProvider>().fetchCategories();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String value) {
    context.read<ProductProvider>().searchProducts(value);
  }

  final GlobalKey _cartKey = GlobalKey();

  void _handleAddToCart(GlobalKey imageKey, var product) {
    if (product.image == null || product.image!.isEmpty) {
      context.read<CartProvider>().addToCart(product);
      return;
    }

    AddToCartAnimation.run(
      context,
      imageKey: imageKey,
      cartKey: _cartKey,
      imageUrl: product.image!,
      onComplete: () {
        context.read<CartProvider>().addToCart(product);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final categoryProvider = context.watch<CategoryProvider>();

    // Display products from provider (already filtered by backend)
    List displayProducts = productProvider.products;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Elegant App Bar
          SliverAppBar(
            pinned: true,
            floating: false,
            elevation: 0,
            // backgroundColor: AppColors.primary, // Default from Theme
            scrolledUnderElevation: 0,
            surfaceTintColor: Colors.transparent,
            title: const Text(
              'Products',
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_none_rounded,
                ),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
            ],
          ),

          // Search Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10.0,
              ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 15,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search products...',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            prefixIcon: Icon(
                              Icons.search_rounded,
                              color: AppColors.primary.withValues(alpha: 0.7),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                          onSubmitted: _onSearch,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 15,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.tune_rounded, color: AppColors.primary),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => const ProductFilterSheet(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
            ),
          ),

          // Categories Filter (Horizontal)
          SliverToBoxAdapter(
            child: Container(
              height: 50,
              margin: const EdgeInsets.only(bottom: 16),
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildCategoryChip(
                    'All',
                    _selectedCategoryId == null,
                    onTap: () {
                      setState(() {
                        _selectedCategoryId = null;
                      });
                      context.read<ProductProvider>().filterProducts(categoryId: null);
                    },
                  ),
                  ...categoryProvider.categories.map((cat) {
                    return _buildCategoryChip(
                      cat.name,
                      _selectedCategoryId == cat.id,
                      onTap: () {
                        setState(() {
                          if (_selectedCategoryId == cat.id) {
                            _selectedCategoryId = null;
                            context.read<ProductProvider>().filterProducts(categoryId: null);
                          } else {
                            _selectedCategoryId = cat.id;
                            context.read<ProductProvider>().filterProducts(categoryId: cat.id);
                          }
                        });
                      },
                    );
                  }),
                ],
              ),
            ),
          ),

          // Product Grid
          productProvider.isLoading
              ? const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              : productProvider.errorMessage != null
              ? SliverFillRemaining(
                  child: Center(
                    child: Text('Error: ${productProvider.errorMessage}'),
                  ),
                )
              : displayProducts.isEmpty
              ? const SliverFillRemaining(
                  child: Center(child: Text('No active products found')),
                )
              : SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  sliver: SliverGrid(
                    key: ValueKey(_selectedCategoryId ?? 'all'), // Key added to force rebuild and re-animate children
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final product = displayProducts[index];
                      return StaggeredEntryWidget( // Wrap with StaggeredEntryWidget
                        index: index,
                        child: RepaintBoundary(
                          child: ProductCardUser(
                            key: ValueKey(product.id),
                            product: product,
                            onAddToCart: (imageKey) async =>
                                _handleAddToCart(imageKey, product),
                          ),
                        ),
                      );
                    }, childCount: displayProducts.length),
                  ),
                ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
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
                child: const Icon(
                  Icons.shopping_cart_rounded,
                  color: Colors.white,
                ),
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

  Widget _buildCategoryChip(
    String label,
    bool isSelected, {
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.grey.shade200,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[700],
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class StaggeredEntryWidget extends StatefulWidget {
  final int index;
  final Widget child;

  const StaggeredEntryWidget({
    super.key,
    required this.index,
    required this.child,
  });

  @override
  State<StaggeredEntryWidget> createState() => _StaggeredEntryWidgetState();
}

class _StaggeredEntryWidgetState extends State<StaggeredEntryWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutQuad,
    ));

    // Stagger delay based on index
    final delay = Duration(milliseconds: 50 * (widget.index % 10)); // Cap delay for long lists
    Future.delayed(delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/product_entity.dart';
import '../../../../core/utils/price_formatter.dart';
import '../../../orders/presentation/providers/cart_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../wishlist/presentation/providers/wishlist_provider.dart';
import 'package:product_management/product_management/presentation/design_system.dart';
import '../../../shared/widgets/love_button.dart';
import '../../../orders/presentation/screens/cart_screen.dart';
import '../../../ratings/presentation/providers/rating_provider.dart';
import '../../../ratings/presentation/screens/rating_form_screen.dart';
import '../../../ratings/presentation/screens/rating_list_screen.dart';
import '../../../inventory/presentation/providers/inventory_provider.dart';

import '../../../shared/widgets/add_to_cart_animation.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final GlobalKey _imageKey = GlobalKey();
  final GlobalKey _cartKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RatingProvider>().fetchRatingsByProduct(widget.product.id);
      context.read<InventoryProvider>().fetchLogsByProduct(widget.product.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Check if user is admin
    final authProvider = context.watch<AuthProvider>();
    final isAdmin = authProvider.isAdmin;

    // Define tabs based on role
    final tabs = [
      const Tab(text: 'Thông tin'),
      const Tab(text: 'Đánh giá'),
      if (isAdmin) const Tab(text: 'Lịch sử'),
    ];

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 400,
              pinned: true,
              stretch: true,
              backgroundColor: AppColors.background,
              elevation: 0,
              iconTheme: const IconThemeData(color: AppColors.primary),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Hero(
                      tag: 'product_image_${widget.product.id}',
                      child: GestureDetector(
                        onTap: () {
                          if (widget.product.image != null && widget.product.image!.isNotEmpty) {
                             // Keep existing dialog logic if needed, or just allow Hero transition back
                             showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                backgroundColor: Colors.transparent,
                                insetPadding: EdgeInsets.zero,
                                child: Stack(
                                  children: [
                                    InteractiveViewer(
                                      child: Image.network(
                                        widget.product.image!,
                                        fit: BoxFit.contain,
                                        height: MediaQuery.of(context).size.height,
                                        width: MediaQuery.of(context).size.width,
                                      ),
                                    ),
                                    Positioned(
                                      top: 40,
                                      right: 20,
                                      child: IconButton(
                                        icon: const Icon(Icons.close, color: Colors.white, size: 30),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                        child: widget.product.image != null && widget.product.image!.isNotEmpty
                            ? Image.network(
                                widget.product.image!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: Colors.grey[100],
                                  child: const Center(
                                    child: Icon(Icons.image_not_supported, size: 64, color: Colors.grey),
                                  ),
                                ),
                              )
                            : Container(
                                color: Colors.grey[100],
                                child: const Center(
                                  child: Icon(Icons.image_not_supported, size: 64, color: Colors.grey),
                                ),
                              ),
                      ),
                    ),
                    // Gradient Overlay to ensure back button visibility
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: 100,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.white.withOpacity(0.8),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                 Consumer2<WishlistProvider, AuthProvider>(
                    builder: (context, wishlistProvider, authProvider, child) {
                      final isWishlisted = wishlistProvider.isInWishlist(widget.product.id);
                      return Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: LoveButton(
                          isLiked: isWishlisted,
                          size: 24,
                          onTap: () async {
                              if (!authProvider.isAuthenticated || authProvider.userId == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Vui lòng đăng nhập')),
                                );
                                return;
                              }
                              if (isWishlisted) {
                                await wishlistProvider.removeFromWishlist(authProvider.userId!, widget.product.id);
                              } else {
                                await wishlistProvider.addToWishlist(authProvider.userId!, widget.product.id);
                              }
                          },
                        ),
                      );
                    },
                 ),
              ],
            ),

            // Tabs pinned below the image
             SliverPersistentHeader(
              delegate: _SliverAppBarDelegate(
                TabBar(
                  labelColor: AppColors.primary,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: AppColors.primary,
                  indicatorWeight: 3,
                  tabs: tabs,
                ),
              ),
              pinned: true,
            ),

            // Tab Content
            SliverFillRemaining(
              hasScrollBody: true,
              child: TabBarView(
                children: [
                  _buildProductInfoTab(),
                  _buildRatingsTab(),
                  if (isAdmin) _buildInventoryHistoryTab(),
                ],
              ),
            ),
          ],
        ),
        bottomSheet: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: widget.product.quantity > 0
                        ? () {
                            if (widget.product.image != null &&
                                widget.product.image!.isNotEmpty) {
                              AddToCartAnimation.run(
                                context,
                                imageKey: _imageKey,
                                cartKey: _cartKey,
                                imageUrl: widget.product.image!,
                                onComplete: () async {
                                  await context
                                      .read<CartProvider>()
                                      .addToCart(widget.product);
                                },
                              );
                            } else {
                              context
                                  .read<CartProvider>()
                                  .addToCart(widget.product);
                            }
                          }
                        : null,
                    icon: const Icon(Icons.shopping_cart),
                    label: const Text('Thêm vào giỏ'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  key: _cartKey,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CartScreen()),
                    );
                  },
                  icon: const Icon(Icons.shopping_cart_outlined),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    padding: const EdgeInsets.all(16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category & Rating
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.product.categoryName ?? 'Sản phẩm',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              if (widget.product.averageRating != null)
                GestureDetector(
                  onTap: () {
                    DefaultTabController.of(context).animateTo(1);
                  },
                  child: Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Colors.amber,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.product.averageRating!.toStringAsFixed(
                          1,
                        ),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        ' (${widget.product.totalRatings ?? 0} đánh giá)',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),

          // Product Name
          Text(
            widget.product.name,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textMain,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),

          // Price
          Text(
            widget.product.price.formatPriceWithCurrency(),
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),

          // Stock Status
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: widget.product.quantity > 0
                  ? Colors.green[50]
                  : Colors.red[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: widget.product.quantity > 0
                    ? Colors.green[200]!
                    : Colors.red[200]!,
              ),
            ),
            child: Text(
              widget.product.quantity > 0
                  ? 'Còn hàng (${widget.product.quantity} sản phẩm)'
                  : 'Hết hàng',
              style: TextStyle(
                color: widget.product.quantity > 0
                    ? Colors.green[700]
                    : Colors.red[700],
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Description Section
          if (widget.product.description != null &&
              widget.product.description!.isNotEmpty) ...[
            const Text(
              'Mô tả',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textMain,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.product.description!,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[700],
                height: 1.6,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRatingsTab() {
    final ratingProvider = context.watch<RatingProvider>();
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Đánh giá & Nhận xét',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textMain,
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RatingFormScreen(
                        productId: widget.product.id,
                        productName: widget.product.name,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.star_outline),
                label: const Text('Viết đánh giá'),
              ),
            ],
          ),
          const SizedBox(height: 12),

          if (ratingProvider.isLoading)
            const Center(child: CircularProgressIndicator())
          else if (ratingProvider.ratings.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Chưa có đánh giá. Hãy là người đầu tiên đánh giá sản phẩm này!',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            )
          else
            ...ratingProvider.ratings.map(
              (rating) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            child: Text(
                              rating.userName
                                      ?.substring(0, 1)
                                      .toUpperCase() ??
                                  'U',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  rating.userName ?? 'Ẩn danh',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                Row(
                                  children: List.generate(5, (i) {
                                    return Icon(
                                      i < rating.rating
                                          ? Icons.star
                                          : Icons.star_border,
                                      size: 16,
                                      color: Colors.amber,
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (rating.comment != null &&
                          rating.comment!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          rating.comment!,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                      const SizedBox(height: 4),
                      Text(
                        _formatDate(rating.createdDate),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildInventoryHistoryTab() {
    final inventoryProvider = context.watch<InventoryProvider>();
    
    return inventoryProvider.isLoading
        ? const Center(child: CircularProgressIndicator())
        : inventoryProvider.errorMessage != null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Lỗi: ${inventoryProvider.errorMessage}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<InventoryProvider>().fetchLogsByProduct(widget.product.id);
                      },
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              )
            : inventoryProvider.productLogs.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.history, size: 80, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        Text(
                          'Không có lịch sử kho',
                          style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Không tìm thấy nhật ký kho cho sản phẩm này',
                          style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () async {
                      await context.read<InventoryProvider>().fetchLogsByProduct(widget.product.id);
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: inventoryProvider.productLogs.length,
                      itemBuilder: (context, index) {
                        final log = inventoryProvider.productLogs[index];
                        final isImport = log.logType.toLowerCase() == 'import';
                        final isAdjustment = log.logType.toLowerCase() == 'adjustment';
                        
                        Color color = isImport 
                            ? Colors.green 
                            : (isAdjustment ? Colors.orange : Colors.red);
                        IconData icon = isImport 
                            ? Icons.download 
                            : (isAdjustment ? Icons.tune : Icons.upload);

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: color.withValues(alpha: 0.1),
                              child: Icon(icon, color: color),
                            ),
                            title: Text(
                              log.logType.toUpperCase(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: color,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(
                                  'Thay đổi: ${log.changeQuantity > 0 ? '+' : ''}${log.changeQuantity}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (log.notes != null && log.notes!.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      'Ghi chú: ${log.notes!}',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 4),
                                Text(
                                  DateFormat('yyyy-MM-dd HH:mm').format(log.createdAt),
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

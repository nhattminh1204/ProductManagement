import 'package:flutter/material.dart';
import 'package:product_management/product_management/presentation/design_system.dart';

import 'package:provider/provider.dart';
import 'package:product_management/core/utils/price_formatter.dart';
import 'package:product_management/features/products/presentation/providers/product_provider.dart';
import 'product_form_screen.dart';
import 'low_stock_products_screen.dart';
import '../widgets/product_filter_bottom_sheet.dart';


class AdminProductListScreen extends StatefulWidget {
  final VoidCallback? onOpenDrawer;

  const AdminProductListScreen({super.key, this.onOpenDrawer});

  @override
  State<AdminProductListScreen> createState() => _AdminProductListScreenState();
}

class _AdminProductListScreenState extends State<AdminProductListScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchProducts();
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

  void _showFilterBottomSheet() {
    final provider = context.read<ProductProvider>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProductFilterBottomSheet(
        initialMinPrice: provider.lastMinPrice,
        initialMaxPrice: provider.lastMaxPrice,
        initialSortBy: provider.lastSortBy,
        initialCategoryId: provider.lastCategoryId,
        onApply: (minPrice, maxPrice, sortBy, categoryId) {
          provider.filterProducts(
            keyword: _searchController.text,
            minPrice: minPrice,
            maxPrice: maxPrice,
            sortBy: sortBy,
            categoryId: categoryId,
          );
        },
        onClear: () {
          provider.fetchProducts();
          _searchController.clear();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu_rounded),
            onPressed: () => widget.onOpenDrawer?.call(),
          ),
        ),
        title: const Text('Quản lý sản phẩm'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Bộ lọc',
            onPressed: _showFilterBottomSheet,
          ),
          IconButton(
            icon: const Icon(Icons.warning_amber_rounded),
            tooltip: 'Sản phẩm sắp hết hàng',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const LowStockProductsScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<ProductProvider>().fetchProducts();
              _searchController.clear();
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm sản phẩm...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: _onSearch,
            ),
          ),
        ),
      ),
      body: productProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : productProvider.errorMessage != null
          ? Center(child: Text('Lỗi: ${productProvider.errorMessage}'))
          : productProvider.products.isEmpty
          ? const Center(child: Text('Không tìm thấy sản phẩm'))
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: productProvider.products.length,
              itemBuilder: (context, index) {
                final product = productProvider.products[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(color: Colors.grey.shade100),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductFormScreen(product: product),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Index Badge
                          Container(
                            width: 28,
                            height: 28,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Image
                          // Image
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: product.image != null && product.image!.isNotEmpty
                                  ? Image.network(
                                      product.image!,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.contain,
                                      errorBuilder: (context, error, stackTrace) =>
                                          Center(
                                            child: Icon(
                                              Icons.image_not_supported,
                                              color: Colors.grey[400],
                                            ),
                                          ),
                                    )
                                  : Center(
                                      child: Icon(Icons.image, color: Colors.grey[400]),
                                    ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    height: 1.2,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8, 
                                        vertical: 4
                                      ),
                                      decoration: BoxDecoration(
                                        color: product.quantity < 10
                                            ? Colors.red.withValues(alpha: 0.1)
                                            : Colors.green.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        'Kho: ${product.quantity}',
                                        style: TextStyle(
                                          color: product.quantity < 10
                                              ? Colors.red
                                              : Colors.green,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      product.price.formatPriceWithCurrency(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.primary,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          
                          // Actions (Popup or direct icons? Let's use simplified direct icons vertically or a popup menu to save space. Actually popup is cleaner for "modern" look)
                          PopupMenuButton(
                            padding: EdgeInsets.zero,
                            icon: Icon(Icons.more_vert, color: Colors.grey[600]),
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Icon(Icons.edit_outlined, size: 20),
                                    SizedBox(width: 8),
                                    Text('Chỉnh sửa'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete_outline, size: 20, color: Colors.red),
                                    SizedBox(width: 8),
                                    Text('Xóa', style: TextStyle(color: Colors.red)),
                                  ],
                                ),
                              ),
                            ],
                            onSelected: (value) async {
                              if (value == 'edit') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ProductFormScreen(product: product),
                                  ),
                                );
                              } else if (value == 'delete') {
                                 showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('Xóa sản phẩm'),
                                    content: Text(
                                      'Bạn có chắc chắn muốn xóa "${product.name}"?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(ctx),
                                        child: const Text('Hủy'),
                                      ),
                                      FilledButton(
                                        style: FilledButton.styleFrom(
                                          backgroundColor: Colors.red,
                                        ),
                                        onPressed: () async {
                                          Navigator.pop(ctx);
                                          await context
                                              .read<ProductProvider>()
                                              .deleteProduct(product.id);
                                        },
                                        child: const Text('Xóa'),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProductFormScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

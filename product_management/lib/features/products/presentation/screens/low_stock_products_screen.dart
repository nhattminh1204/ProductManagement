import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card_admin.dart';
import 'package:product_management/product_management/presentation/design_system.dart';
import 'product_detail_screen.dart';
import '../../domain/entities/product_entity.dart';

class LowStockProductsScreen extends StatefulWidget {
  const LowStockProductsScreen({super.key});

  @override
  State<LowStockProductsScreen> createState() => _LowStockProductsScreenState();
}

class _LowStockProductsScreenState extends State<LowStockProductsScreen> {
  String _sortBy = 'quantity'; // quantity, name
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchLowStockProducts();
    });
  }

  List<Product> _getSortedProducts(List<Product> products) {
    final sorted = List<Product>.from(products);
    sorted.sort((a, b) {
      if (_sortBy == 'quantity') {
        return _sortAscending
            ? a.quantity.compareTo(b.quantity)
            : b.quantity.compareTo(a.quantity);
      } else {
        return _sortAscending
            ? a.name.compareTo(b.name)
            : b.name.compareTo(a.name);
      }
    });
    return sorted;
  }

  Color _getStockColor(int quantity) {
    if (quantity <= 5) return Colors.red;
    if (quantity <= 10) return Colors.orange;
    return Colors.amber;
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Low Stock Products'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: (value) {
              setState(() {
                if (value == 'quantity_asc' || value == 'quantity_desc') {
                  _sortBy = 'quantity';
                  _sortAscending = value == 'quantity_asc';
                } else {
                  _sortBy = 'name';
                  _sortAscending = value == 'name_asc';
                }
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'quantity_asc',
                child: Text('Sort by Quantity (Low to High)'),
              ),
              const PopupMenuItem(
                value: 'quantity_desc',
                child: Text('Sort by Quantity (High to Low)'),
              ),
              const PopupMenuItem(
                value: 'name_asc',
                child: Text('Sort by Name (A-Z)'),
              ),
              const PopupMenuItem(
                value: 'name_desc',
                child: Text('Sort by Name (Z-A)'),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<ProductProvider>().fetchLowStockProducts();
            },
          ),
        ],
      ),
      body: productProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : productProvider.errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Error: ${productProvider.errorMessage}'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<ProductProvider>().fetchLowStockProducts();
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : productProvider.lowStockProducts.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inventory_2_outlined,
                              size: 80, color: Colors.grey[300]),
                          const SizedBox(height: 16),
                          Text(
                            'No low stock products',
                            style: TextStyle(
                                fontSize: 18, color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'All products have sufficient stock',
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[500]),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        await context
                            .read<ProductProvider>()
                            .fetchLowStockProducts();
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _getSortedProducts(
                                productProvider.lowStockProducts)
                            .length,
                        itemBuilder: (context, index) {
                          final products = _getSortedProducts(
                              productProvider.lowStockProducts);
                          final product = products[index];
                          final stockColor = _getStockColor(product.quantity);

                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        ProductDetailScreen(product: product),
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  children: [
                                    // Product Image
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.grey[100],
                                        image: product.image != null &&
                                                product.image!.isNotEmpty
                                            ? DecorationImage(
                                                image:
                                                    NetworkImage(product.image!),
                                                fit: BoxFit.cover,
                                              )
                                            : null,
                                      ),
                                      child: product.image == null ||
                                              product.image!.isEmpty
                                          ? const Icon(
                                              Icons.image_not_supported,
                                              color: Colors.grey,
                                            )
                                          : null,
                                    ),
                                    const SizedBox(width: 16),
                                    // Product Info
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product.name,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          if (product.categoryName != null)
                                            Text(
                                              product.categoryName!,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.inventory_2,
                                                size: 16,
                                                color: stockColor,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                'Stock: ${product.quantity}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: stockColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Warning Badge
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: stockColor.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: stockColor,
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.warning_amber_rounded,
                                            size: 16,
                                            color: stockColor,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            product.quantity <= 5
                                                ? 'Critical'
                                                : product.quantity <= 10
                                                    ? 'Low'
                                                    : 'Warning',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: stockColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}



import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:product_management/product_management/presentation/design_system.dart';
import '../../../../features/categories/presentation/providers/category_provider.dart';

class ProductFilterBottomSheet extends StatefulWidget {
  final double? initialMinPrice;
  final double? initialMaxPrice;
  final String? initialSortBy;
  final int? initialCategoryId;
  final Function(double? minPrice, double? maxPrice, String? sortBy, int? categoryId) onApply;
  final VoidCallback onClear;

  const ProductFilterBottomSheet({
    super.key,
    this.initialMinPrice,
    this.initialMaxPrice,
    this.initialSortBy,
    this.initialCategoryId,
    required this.onApply,
    required this.onClear,
  });

  @override
  State<ProductFilterBottomSheet> createState() => _ProductFilterBottomSheetState();
}

class _ProductFilterBottomSheetState extends State<ProductFilterBottomSheet> {
  late TextEditingController _minPriceController;
  late TextEditingController _maxPriceController;
  String? _selectedSortBy;
  int? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _minPriceController = TextEditingController(
      text: widget.initialMinPrice?.toString() ?? '',
    );
    _maxPriceController = TextEditingController(
      text: widget.initialMaxPrice?.toString() ?? '',
    );
    _selectedSortBy = widget.initialSortBy;
    _selectedCategoryId = widget.initialCategoryId;

    // Fetch categories if empty
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final categoryProvider = context.read<CategoryProvider>();
      if (categoryProvider.categories.isEmpty) {
        categoryProvider.fetchCategories();
      }
    });
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If keyboard is open, we want the sheet to move up? 
    // Usually bottom sheet handles this, but let's be safe with SingleChildScrollView
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Bộ lọc sản phẩm',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 16),
            
            // Sort By
            const Text(
              'Sắp xếp',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildSortChip('Mới nhất', 'newest'),
                _buildSortChip('Giá tăng dần', 'price_asc'),
                _buildSortChip('Giá giảm dần', 'price_desc'),
                _buildSortChip('Tên A-Z', 'name_asc'),
              ],
            ),
            const SizedBox(height: 24),

            // Price Range
            const Text(
              'Khoảng giá',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _minPriceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Tối thiểu',
                      hintText: '0',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      prefixIcon: const Icon(Icons.attach_money, size: 16),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text('-', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: TextField(
                    controller: _maxPriceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Tối đa',
                      hintText: 'Max',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      prefixIcon: const Icon(Icons.attach_money, size: 16),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Category
            const Text(
              'Danh mục',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Consumer<CategoryProvider>(
              builder: (context, categoryProvider, _) {
                if (categoryProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                final categories = categoryProvider.categories;
                if (categories.isEmpty) {
                  return const Text('Chưa có danh mục nào');
                }
                
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: categories.map((cat) {
                    final isSelected = _selectedCategoryId == cat.id;
                    return ChoiceChip(
                      label: Text(cat.name),
                      selected: isSelected,
                      selectedColor: AppColors.primary.withValues(alpha: 0.2),
                      labelStyle: TextStyle(
                        color: isSelected ? AppColors.primary : Colors.black,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategoryId = selected ? cat.id : null;
                        });
                      },
                    );
                  }).toList(),
                );
              },
            ),

            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      widget.onClear();
                      Navigator.pop(context);
                    },
                    child: const Text('Xóa bộ lọc'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      final minPrice = double.tryParse(_minPriceController.text);
                      final maxPrice = double.tryParse(_maxPriceController.text);
                      widget.onApply(minPrice, maxPrice, _selectedSortBy, _selectedCategoryId);
                      Navigator.pop(context);
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    child: const Text('Áp dụng'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortChip(String label, String value) {
    final isSelected = _selectedSortBy == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: AppColors.primary.withValues(alpha: 0.2),
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primary : Colors.black,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      onSelected: (selected) {
        setState(() {
          _selectedSortBy = selected ? value : null;
        });
      },
    );
  }
}

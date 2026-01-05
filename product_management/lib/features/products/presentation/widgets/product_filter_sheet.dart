import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../../../shared/design_system.dart';

class ProductFilterSheet extends StatefulWidget {
  const ProductFilterSheet({super.key});

  @override
  State<ProductFilterSheet> createState() => _ProductFilterSheetState();
}

class _ProductFilterSheetState extends State<ProductFilterSheet> {
  final _minPriceController = TextEditingController();
  final _maxPriceController = TextEditingController();
  double? _selectedRating;
  String? _selectedSort;

  @override
  void initState() {
    super.initState();
    final provider = context.read<ProductProvider>();
    if (provider.lastMinPrice != null) {
      _minPriceController.text = provider.lastMinPrice!.toStringAsFixed(0);
    }
    if (provider.lastMaxPrice != null) {
      _maxPriceController.text = provider.lastMaxPrice!.toStringAsFixed(0);
    }
    _selectedRating = provider.lastMinRating;
    _selectedSort = provider.lastSortBy;
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  void _applyFilter() {
    final minPrice = double.tryParse(_minPriceController.text);
    final maxPrice = double.tryParse(_maxPriceController.text);

    context.read<ProductProvider>().filterProducts(
      keyword: context.read<ProductProvider>().lastKeyword,
      categoryId: context.read<ProductProvider>().lastCategoryId,
      minPrice: minPrice,
      maxPrice: maxPrice,
      minRating: _selectedRating,
      sortBy: _selectedSort,
    );
    Navigator.pop(context);
  }

  void _resetFilter() {
    setState(() {
      _minPriceController.clear();
      _maxPriceController.clear();
      _selectedRating = null;
      _selectedSort = null;
    });
    // Apply reset immediately or wait for Apply button? 
    // Usually 'Reset' just clears UI, User hits Apply. Or Reset applies immediately.
    // I'll leave it to Apply button for explicit action, or call apply here.
    // Let's call apply here to clear backend state too.
    context.read<ProductProvider>().filterProducts(
      keyword: context.read<ProductProvider>().lastKeyword,
      categoryId: context.read<ProductProvider>().lastCategoryId,
      minPrice: null,
      maxPrice: null,
      minRating: null,
      sortBy: null,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Bộ lọc & Sắp xếp',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textMain,
                  ),
                ),
                TextButton(
                  onPressed: _resetFilter,
                  child: const Text('Đặt lại'),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Price Range
            const Text(
              'Khoảng giá (VNĐ)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _minPriceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Tối thiểu',
                      hintText: '0',
                      prefixIcon: Icon(Icons.attach_money, size: 16), // Or currency symbol
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _maxPriceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Tối đa',
                      hintText: 'Max',
                      prefixIcon: Icon(Icons.attach_money, size: 16),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Rating
            const Text(
              'Đánh giá tối thiểu',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [4, 3, 2, 1].map((rating) {
                final isSelected = _selectedRating == rating.toDouble();
                return ChoiceChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('$rating'),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.star,
                        size: 16,
                        color: isSelected ? Colors.white : Colors.amber,
                      ),
                      const Text(' & lên'),
                    ],
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedRating = selected ? rating.toDouble() : null;
                    });
                  },
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Sort By
            const Text(
              'Sắp xếp theo',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildSortChip('Mới nhất', 'newest'),
                _buildSortChip('Giá: Thấp đến Cao', 'price_asc'),
                _buildSortChip('Giá: Cao đến Thấp', 'price_desc'),
                _buildSortChip('Đánh giá cao nhất', 'rating'),
              ],
            ),
            const SizedBox(height: 32),

            // Apply Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _applyFilter,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Áp dụng',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 24), // Bottom padding
          ],
        ),
      ),
    );
  }

  Widget _buildSortChip(String label, String value) {
    final isSelected = _selectedSort == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedSort = selected ? value : null;
        });
      },
      selectedColor: AppColors.primary,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black87,
      ),
    );
  }
}

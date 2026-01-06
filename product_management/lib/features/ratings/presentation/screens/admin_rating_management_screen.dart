import 'package:flutter/material.dart';
import 'package:product_management/product_management/presentation/design_system.dart';
import 'package:product_management/features/shared/presentation/widgets/admin_drawer.dart';
import 'package:provider/provider.dart';
import '../providers/rating_provider.dart';
import '../widgets/rating_filter_widget.dart';
import '../widgets/rating_list_item.dart';

class AdminRatingManagementScreen extends StatefulWidget {
  const AdminRatingManagementScreen({super.key});

  @override
  State<AdminRatingManagementScreen> createState() =>
      _AdminRatingManagementScreenState();
}

class _AdminRatingManagementScreenState
    extends State<AdminRatingManagementScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RatingProvider>().fetchAllRatings();
    });
  }

  void _showDeleteConfirmation(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc chắn muốn xóa đánh giá này không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              final success =
                  await context.read<RatingProvider>().deleteRating(id);
              if (success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã xóa đánh giá')),
                );
                context.read<RatingProvider>().fetchAllRatings();
              }
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  void _showFilter(BuildContext context) {
    final provider = context.read<RatingProvider>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RatingFilterWidget(
        initialStars: provider.filterStars,
        initialDate: provider.filterDate,
        onApply: (stars, date) {
          provider.setFilters(stars: stars, date: date);
        },
        onClear: () {
          provider.clearFilters();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RatingProvider>();

    return Scaffold(
      drawer: const AdminDrawer(currentScreen: 'ratings'),
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu_rounded),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text('Quản lý đánh giá'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Tìm theo user, sản phẩm...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    ),
                    onChanged: (value) {
                      provider.setFilters(query: value);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => _showFilter(context),
                  icon: const Icon(Icons.filter_list),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.ratings.isEmpty
              ? const Center(child: Text('Không có đánh giá nào'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.ratings.length,
                  itemBuilder: (context, index) {
                    final rating = provider.ratings[index];
                    return RatingListItem(
                      rating: rating,
                      onDelete: () => _showDeleteConfirmation(rating.id),
                    );
                  },
                ),
    );
  }
}

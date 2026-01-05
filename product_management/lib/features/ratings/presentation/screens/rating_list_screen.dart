import 'package:flutter/material.dart';
import 'package:product_management/features/shared/design_system.dart';
import 'package:provider/provider.dart';
import '../providers/rating_provider.dart';

class RatingListScreen extends StatefulWidget {
  final int? productId;
  final int? userId;

  const RatingListScreen({super.key, this.productId, this.userId});

  @override
  State<RatingListScreen> createState() => _RatingListScreenState();
}

class _RatingListScreenState extends State<RatingListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ratingProvider = context.read<RatingProvider>();
      if (widget.productId != null) {
        ratingProvider.fetchRatingsByProduct(widget.productId!);
      } else if (widget.userId != null) {
        ratingProvider.fetchRatingsByUser(widget.userId!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ratingProvider = context.watch<RatingProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.productId != null
              ? 'Đánh giá sản phẩm'
              : widget.userId != null
              ? 'Đánh giá của tôi'
              : 'Tất cả đánh giá',
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: ratingProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ratingProvider.errorMessage != null
          ? Center(child: Text('Lỗi: ${ratingProvider.errorMessage}'))
          : ratingProvider.ratings.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.star_border, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('Chưa có đánh giá nào'),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: ratingProvider.ratings.length,
              itemBuilder: (context, index) {
                final rating = ratingProvider.ratings[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              child: Text(
                                rating.userName
                                        ?.substring(0, 1)
                                        .toUpperCase() ??
                                    'U',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    rating.userName ?? 'Ẩn danh',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  if (rating.productName != null)
                                    Text(
                                      rating.productName!,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Row(
                              children: List.generate(5, (i) {
                                return Icon(
                                  i < rating.rating
                                      ? Icons.star
                                      : Icons.star_border,
                                  size: 20,
                                  color: Colors.amber,
                                );
                              }),
                            ),
                          ],
                        ),
                        if (rating.comment != null &&
                            rating.comment!.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Text(
                            rating.comment!,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                        const SizedBox(height: 8),
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
                );
              },
            ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

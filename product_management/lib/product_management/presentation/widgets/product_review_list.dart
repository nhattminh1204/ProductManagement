import 'package:flutter/material.dart';
import '../../domain/entities/rating.dart';

class ProductReviewList extends StatelessWidget {
  final List<Rating> reviews;
  final bool isLoading;

  const ProductReviewList({
    super.key,
    required this.reviews,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (reviews.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: [
            Icon(Icons.rate_review_outlined, size: 48, color: Colors.grey[300]),
            const SizedBox(height: 8),
            Text('No reviews yet. Be the first!', style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      );
    }

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: reviews.length,
      separatorBuilder: (context, index) => const Divider(height: 24),
      itemBuilder: (context, index) {
        final review = reviews[index];
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             CircleAvatar(
               backgroundColor: Colors.grey[200],
               child: Text(
                 review.userName?.isNotEmpty == true ? review.userName![0].toUpperCase() : 'U',
                 style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
               ),
             ),
             const SizedBox(width: 12),
             Expanded(
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Text(
                         review.userName ?? 'User',
                         style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                       ),
                       Text(
                         review.createdAt != null 
                             ? "${review.createdAt!.day}/${review.createdAt!.month}/${review.createdAt!.year}" 
                             : "",
                         style: TextStyle(color: Colors.grey[400], fontSize: 12),
                       ),
                     ],
                   ),
                   const SizedBox(height: 4),
                   Row(
                     children: List.generate(5, (starIndex) {
                       return Icon(
                         starIndex < review.rating ? Icons.star_rounded : Icons.star_border_rounded,
                         size: 16,
                         color: Colors.amber,
                       );
                     }),
                   ),
                   if (review.comment != null && review.comment!.isNotEmpty) ...[
                     const SizedBox(height: 8),
                     Text(
                       review.comment!,
                       style: TextStyle(color: Colors.grey[800], height: 1.4),
                     ),
                   ],
                 ],
               ),
             ),
          ],
        );
      },
    );
  }
}

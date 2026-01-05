import '../../../../features/products/domain/entities/product_entity.dart';

class WishlistItem {
  final int id;
  final int userId;
  final int productId;
  final Product? product;
  final DateTime createdAt;

  WishlistItem({
    required this.id,
    required this.userId,
    required this.productId,
    this.product,
    required this.createdAt,
  });
}

import '../../domain/entities/wishlist_item_entity.dart';
import '../../../../features/products/data/models/product_model.dart';
import '../../../../features/products/domain/entities/product_entity.dart';

class WishlistModel extends WishlistItem {
  WishlistModel({
    required super.id,
    required super.userId,
    required super.productId,
    super.product,
    required super.createdAt,
  });

  factory WishlistModel.fromJson(Map<String, dynamic> json) {
    Product? productEntity;
    if (json['product'] != null) {
      final productModel = ProductModel.fromJson(json['product']);
      productEntity = Product(
        id: productModel.id,
        name: productModel.name,
        image: productModel.image,
        price: productModel.price,
        quantity: productModel.quantity,
        status: productModel.status,
        categoryId: productModel.categoryId,
        categoryName: productModel.categoryName,
        averageRating: productModel.averageRating,
        totalRatings: productModel.totalRatings,
      );
    } else if (json['productName'] != null) {
      // Fallback for older API response or if product object is missing
      productEntity = Product(
        id: json['productId'] ?? 0,
        name: json['productName'] ?? '',
        image: json['productImage'],
        price: (json['productPrice'] is num) 
            ? (json['productPrice'] as num).toDouble() 
            : double.tryParse(json['productPrice'].toString()) ?? 0.0,
        quantity: 1, // Default
        status: 'active',
        categoryId: 0,
      );
    }
    return WishlistModel(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      productId: json['productId'] ?? 0,
      product: productEntity,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'productId': productId,
      'product': product != null ? {
        'id': product!.id,
        'name': product!.name,
        'image': product!.image,
        'price': product!.price,
        'quantity': product!.quantity,
        'status': product!.status,
        'categoryId': product!.categoryId,
        'categoryName': product!.categoryName,
        'averageRating': product!.averageRating,
        'totalRatings': product!.totalRatings,
      } : null,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

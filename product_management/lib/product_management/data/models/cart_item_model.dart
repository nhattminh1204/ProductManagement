import '../../domain/entities/cart_item.dart';
import '../../../features/products/data/models/product_model.dart';
import '../../domain/entities/product.dart';

class CartItemModel extends CartItem {
  CartItemModel({
    super.id,
    required super.product,
    required super.quantity,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    // API returns flat structure: productId, productName, productImage, productPrice
    // OR nested structure: product: {...}
    Product productEntity;
    
    if (json.containsKey('product') && json['product'] is Map) {
      // Nested structure
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
    } else {
      // Flat structure from API (productId, productName, productImage, productPrice)
      print('DEBUG CartItemModel: Parsing flat structure - productId=${json['productId']}, productName=${json['productName']}, productPrice=${json['productPrice']}');
      productEntity = Product(
        id: json['productId'] ?? 0,
        name: json['productName'] ?? '',
        image: json['productImage'],
        price: (json['productPrice'] ?? 0.0).toDouble(),
        quantity: json['productStock'] ?? 0, // Get avail stock from API
        status: 'ACTIVE', // Default
        categoryId: 0, // Not provided
        categoryName: null,
        averageRating: null,
        totalRatings: null,
      );
    }
    
    return CartItemModel(
      id: json['id'],
      product: productEntity,
      quantity: json['quantity'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': {
        'id': product.id,
        'name': product.name,
        'image': product.image,
        'price': product.price,
        'quantity': product.quantity,
        'status': product.status,
        'categoryId': product.categoryId,
        'categoryName': product.categoryName,
        'averageRating': product.averageRating,
        'totalRatings': product.totalRatings,
      },
      'quantity': quantity,
    };
  }
}

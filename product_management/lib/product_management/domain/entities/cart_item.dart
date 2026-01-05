import 'product.dart';

class CartItem {
  final int? id; // Optional, might not be needed if we use product_id for updates
  final Product product;
  final int quantity;

  CartItem({
    this.id,
    required this.product,
    required this.quantity,
  });

  double get totalPrice => product.price * quantity;
}

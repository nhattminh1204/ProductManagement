import '../entities/cart_item.dart';

abstract class CartRepository {
  Future<List<CartItem>> getCart(int userId);
  Future<CartItem> addToCart(int userId, int productId, int quantity);
  Future<CartItem> updateCartItem(int userId, int productId, int quantity);
  Future<void> removeFromCart(int userId, int productId);
  Future<void> clearCart(int userId);
}

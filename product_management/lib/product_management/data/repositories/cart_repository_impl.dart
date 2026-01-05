import '../../../api/api_service.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final ApiService _apiService;

  CartRepositoryImpl(this._apiService);

  @override
  Future<List<CartItem>> getCart(int userId) async {
    return await _apiService.getCart(userId);
  }

  @override
  Future<CartItem> addToCart(int userId, int productId, int quantity) async {
    return await _apiService.addToCart(userId, productId, quantity);
  }

  @override
  Future<CartItem> updateCartItem(int userId, int productId, int quantity) async {
    return await _apiService.updateCartItem(userId, productId, quantity);
  }

  @override
  Future<void> removeFromCart(int userId, int productId) async {
    await _apiService.removeFromCart(userId, productId);
  }

  @override
  Future<void> clearCart(int userId) async {
    await _apiService.clearCart(userId);
  }
}

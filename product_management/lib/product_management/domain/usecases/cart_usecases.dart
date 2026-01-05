import '../repositories/cart_repository.dart';
import '../entities/cart_item.dart';

class GetCartUseCase {
  final CartRepository repository;
  GetCartUseCase(this.repository);

  Future<List<CartItem>> call(int userId) {
    return repository.getCart(userId);
  }
}

class AddToCartUseCase {
  final CartRepository repository;
  AddToCartUseCase(this.repository);

  Future<CartItem> call(int userId, int productId, int quantity) {
    return repository.addToCart(userId, productId, quantity);
  }
}

class UpdateCartItemUseCase {
  final CartRepository repository;
  UpdateCartItemUseCase(this.repository);

  Future<CartItem> call(int userId, int productId, int quantity) {
    return repository.updateCartItem(userId, productId, quantity);
  }
}

class RemoveCartItemUseCase {
  final CartRepository repository;
  RemoveCartItemUseCase(this.repository);

  Future<void> call(int userId, int productId) {
    return repository.removeFromCart(userId, productId);
  }
}

class ClearCartUseCase {
  final CartRepository repository;
  ClearCartUseCase(this.repository);

  Future<void> call(int userId) {
    return repository.clearCart(userId);
  }
}

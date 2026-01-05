import '../../domain/repositories/wishlist_repository.dart';
import '../../domain/entities/wishlist_item_entity.dart';
import '../../../../api/api_service.dart';

class WishlistRepositoryImpl implements WishlistRepository {
  final ApiService apiService;

  WishlistRepositoryImpl(this.apiService);

  @override
  Future<List<WishlistItem>> getWishlist(int userId) async {
    return await apiService.getWishlist(userId);
  }

  @override
  Future<WishlistItem?> addToWishlist(int userId, int productId) async {
    try {
      final item = await apiService.addToWishlist(userId, productId);
      return item;
    } catch (e) {
      // Potentially log error or rethrow if needed
      return null;
    }
  }

  @override
  Future<bool> removeFromWishlist(int userId, int productId) async {
    try {
      await apiService.removeFromWishlist(userId, productId);
      return true;
    } catch (e) {
      return false;
    }
  }
}

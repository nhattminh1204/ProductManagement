import '../entities/wishlist_item_entity.dart';

abstract class WishlistRepository {
  Future<List<WishlistItem>> getWishlist(int userId);
  Future<WishlistItem?> addToWishlist(int userId, int productId);
  Future<bool> removeFromWishlist(int userId, int productId);
}

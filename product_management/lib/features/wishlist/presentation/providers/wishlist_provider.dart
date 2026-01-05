import 'package:flutter/material.dart';
import '../../domain/repositories/wishlist_repository.dart';
import '../../domain/entities/wishlist_item_entity.dart';

class WishlistProvider extends ChangeNotifier {
  final WishlistRepository repository;
  
  List<WishlistItem> _items = [];
  bool _isLoading = false;
  String? _errorMessage;

  WishlistProvider(this.repository);

  List<WishlistItem> get items => _items;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchWishlist(int userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _items = await repository.getWishlist(userId);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addToWishlist(int userId, int productId) async {
    final newItem = await repository.addToWishlist(userId, productId);
    if (newItem != null) {
      _items.add(newItem);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> removeFromWishlist(int userId, int productId) async {
    // Optimistic update
    final index = _items.indexWhere((item) => item.productId == productId);
    WishlistItem? removedItem;
    if (index != -1) {
      removedItem = _items[index];
      _items.removeAt(index);
      notifyListeners();
    }

    final success = await repository.removeFromWishlist(userId, productId);
    if (!success && removedItem != null) {
      // Revert if API fails
      _items.insert(index, removedItem);
      notifyListeners();
    }
    return success;
  }

  bool isInWishlist(int productId) {
    return _items.any((item) => item.productId == productId);
  }
}

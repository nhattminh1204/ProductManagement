import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../products/domain/entities/product_entity.dart';
import '../../../../api/api_service.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get totalPrice => product.price * quantity;

  Map<String, dynamic> toJson() {
    return {'productId': product.id, 'quantity': quantity};
  }

  static CartItem fromJson(Map<String, dynamic> json, Product product) {
    return CartItem(product: product, quantity: json['quantity'] as int);
  }
}

class CartProvider extends ChangeNotifier {
  final ApiService? _apiService;
  AuthProvider? _authProvider;

  List<CartItem> _items = [];
  bool _isLoading = false;
  String? _errorMessage;
  static const String _cartKey = 'cart_items';

  CartProvider({ApiService? apiService, AuthProvider? authProvider})
    : _apiService = apiService,
      _authProvider = authProvider;

  void updateAuthProvider(AuthProvider authProvider) {
    _authProvider = authProvider;
    notifyListeners();
  }

  List<CartItem> get items => _items;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  double get totalAmount {
    return _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  int get getItemCount {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  bool get isEmpty => _items.isEmpty;

  /// Load cart from backend (if user is logged in) or local storage
  Future<void> loadCart(List<Product> allProducts) async {
    _isLoading = true;
    notifyListeners();

    try {
      // If user is logged in, load from backend first
      if (_authProvider?.isAuthenticated == true &&
          _authProvider?.userId != null &&
          _apiService != null) {
        try {
          final userId = _authProvider!.userId!;
          print('DEBUG: Loading cart from backend for userId=$userId');
          final cartItems = await _apiService!.getCart(userId);
          print('DEBUG: Received ${cartItems.length} cart items from backend');

          // Convert CartItemModel to CartItem
          _items = [];
          for (var cartItemModel in cartItems) {
            try {
              // Use product directly from API response (it already has all info)
              // Convert from product_management/domain/entities/product.dart to features/products/domain/entities/product_entity.dart
              final productFromApi = cartItemModel.product;
              final product = Product(
                id: productFromApi.id,
                name: productFromApi.name,
                image: productFromApi.image,
                price: productFromApi.price,
                quantity: productFromApi.quantity,
                status: productFromApi.status,
                categoryId: productFromApi.categoryId,
                categoryName: productFromApi.categoryName,
                averageRating: productFromApi.averageRating,
                totalRatings: productFromApi.totalRatings,
              );

              _items.add(
                CartItem(product: product, quantity: cartItemModel.quantity),
              );
              print(
                'DEBUG: Added cart item - productId=${product.id}, quantity=${cartItemModel.quantity}',
              );
            } catch (e) {
              print('ERROR: Failed to add cart item: $e');
              // Skip items with invalid data
              continue;
            }
          }

          print('DEBUG: Successfully loaded ${_items.length} items to cart');
          // Save to local storage for offline access
          await _saveCart();
          _errorMessage = null;
          _isLoading = false;
          notifyListeners();
          return;
        } catch (e) {
          // If backend fails, fall back to local storage
          print('ERROR: Failed to load cart from backend: $e');
        }
      }

      // Load from local storage (for offline or guest users)
      final prefs = await SharedPreferences.getInstance();
      final cartJson = prefs.getString(_cartKey);

      if (cartJson != null) {
        final List<dynamic> cartData = json.decode(cartJson);
        _items = [];

        for (var itemData in cartData) {
          try {
            final productId = itemData['productId'] as int;
            final quantity = itemData['quantity'] as int;

            // Find product from allProducts list
            final product = allProducts.firstWhere(
              (p) => p.id == productId,
              orElse: () => throw Exception('Product not found'),
            );

            _items.add(CartItem(product: product, quantity: quantity));
          } catch (e) {
            // Skip items with products that no longer exist
            continue;
          }
        }
      }

      // If user is logged in, sync local cart to backend
      if (_authProvider?.isAuthenticated == true &&
          _authProvider?.userId != null &&
          _apiService != null) {
        await _syncLocalCartToBackend();
      }

      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to load cart: $e';
      // Clear corrupted cart data
      await _clearCartStorage();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Sync local cart to backend
  Future<void> _syncLocalCartToBackend() async {
    if (_authProvider?.userId == null || _apiService == null) return;

    try {
      final userId = _authProvider!.userId!;

      // Get current backend cart
      final backendCart = await _apiService!.getCart(userId);
      final backendProductIds = backendCart
          .map((item) => item.product.id)
          .toSet();

      // Add/update items from local cart to backend
      for (var localItem in _items) {
        if (backendProductIds.contains(localItem.product.id)) {
          // Update quantity if different
          final backendItem = backendCart.firstWhere(
            (item) => item.product.id == localItem.product.id,
          );
          if (backendItem.quantity != localItem.quantity) {
            await _apiService!.updateCartItem(
              userId,
              localItem.product.id,
              localItem.quantity,
            );
          }
        } else {
          // Add new item to backend
          await _apiService!.addToCart(
            userId,
            localItem.product.id,
            localItem.quantity,
          );
        }
      }

      // Remove items from backend that are not in local cart
      for (var backendItem in backendCart) {
        if (!_items.any((item) => item.product.id == backendItem.product.id)) {
          await _apiService!.removeFromCart(userId, backendItem.product.id);
        }
      }
    } catch (e) {
      print('Failed to sync cart to backend: $e');
      // Don't throw error, just log it
    }
  }

  /// Save cart to SharedPreferences
  Future<void> _saveCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = json.encode(
        _items.map((item) => item.toJson()).toList(),
      );
      await prefs.setString(_cartKey, cartJson);
    } catch (e) {
      _errorMessage = 'Failed to save cart: $e';
    }
  }

  /// Clear cart from storage
  Future<void> _clearCartStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_cartKey);
    } catch (e) {
      // Ignore errors when clearing
    }
  }

  Future<void> addToCart(Product product) async {
    _errorMessage = null;
    final index = _items.indexWhere((item) => item.product.id == product.id);
    int newQuantity;
    bool isUpdate = false;

    // Validate stock before proceeding
    if (index >= 0) {
      if (_items[index].quantity + 1 > product.quantity) {
        _errorMessage = 'Cannot add more. Out of stock.';
        notifyListeners();
        return;
      } else {
        newQuantity = _items[index].quantity + 1;
        isUpdate = true;
      }
    } else {
      if (product.quantity > 0) {
        newQuantity = 1;
      } else {
        _errorMessage = 'Product is out of stock.';
        notifyListeners();
        return;
      }
    }

    // If user is logged in, save to database first
    if (_authProvider?.isAuthenticated == true &&
        _authProvider?.userId != null &&
        _apiService != null) {
      try {
        final userId = _authProvider!.userId!;
        print(
          'DEBUG: Adding to cart - userId=$userId, productId=${product.id}, quantity=$newQuantity, isUpdate=$isUpdate',
        );

        if (isUpdate) {
          await _apiService!.updateCartItem(userId, product.id, newQuantity);
        } else {
          await _apiService!.addToCart(userId, product.id, newQuantity);
        }

        print('DEBUG: Cart API call successful');

        // Update local state after successful API call
        if (index >= 0) {
          _items[index].quantity = newQuantity;
        } else {
          _items.add(CartItem(product: product, quantity: newQuantity));
        }
        notifyListeners();
        // Don't save to local storage when user is logged in
      } catch (e) {
        print('ERROR: Failed to add to cart in database: $e');
        _errorMessage = 'Failed to add to cart: $e';
        notifyListeners();
        return;
      }
    } else {
      // Guest user - save to local storage only
      if (index >= 0) {
        _items[index].quantity = newQuantity;
      } else {
        _items.add(CartItem(product: product, quantity: newQuantity));
      }
      notifyListeners();
      await _saveCart();
    }
  }

  Future<void> updateQuantity(int productId, int quantity) async {
    _errorMessage = null;
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index < 0) return;

    if (quantity > _items[index].product.quantity) {
      _errorMessage = 'Cannot add more. Max stock reached.';
      notifyListeners();
      return;
    } else if (quantity <= 0) {
      await removeFromCart(productId);
      return;
    }

    // If user is logged in, save to database first
    if (_authProvider?.isAuthenticated == true &&
        _authProvider?.userId != null &&
        _apiService != null) {
      try {
        final userId = _authProvider!.userId!;
        await _apiService!.updateCartItem(userId, productId, quantity);

        // Update local state after successful API call
        _items[index].quantity = quantity;
        notifyListeners();
        // Don't save to local storage when user is logged in
      } catch (e) {
        print('Failed to update quantity in database: $e');
        _errorMessage = 'Failed to update quantity: $e';
        notifyListeners();
        return;
      }
    } else {
      // Guest user - save to local storage only
      _items[index].quantity = quantity;
      notifyListeners();
      await _saveCart();
    }
  }

  Future<void> removeFromCart(int productId) async {
    // If user is logged in, remove from database first
    if (_authProvider?.isAuthenticated == true &&
        _authProvider?.userId != null &&
        _apiService != null) {
      try {
        final userId = _authProvider!.userId!;
        await _apiService!.removeFromCart(userId, productId);

        // Update local state after successful API call
        _items.removeWhere((item) => item.product.id == productId);
        notifyListeners();
        // Don't save to local storage when user is logged in
      } catch (e) {
        print('Failed to remove from cart in database: $e');
        _errorMessage = 'Failed to remove from cart: $e';
        notifyListeners();
        return;
      }
    } else {
      // Guest user - remove from local storage only
      _items.removeWhere((item) => item.product.id == productId);
      notifyListeners();
      await _saveCart();
    }
  }

  Future<void> clearCart() async {
    // If user is logged in, clear from database first
    if (_authProvider?.isAuthenticated == true &&
        _authProvider?.userId != null &&
        _apiService != null) {
      try {
        final userId = _authProvider!.userId!;
        await _apiService!.clearCart(userId);

        // Update local state after successful API call
        _items.clear();
        notifyListeners();
        // Don't clear local storage when user is logged in
      } catch (e) {
        print('Failed to clear cart in database: $e');
        _errorMessage = 'Failed to clear cart: $e';
        notifyListeners();
        return;
      }
    } else {
      // Guest user - clear from local storage only
      _items.clear();
      notifyListeners();
      await _clearCartStorage();
    }
  }
}

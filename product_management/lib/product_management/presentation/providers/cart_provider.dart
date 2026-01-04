import 'package:flutter/material.dart';
import 'package:product_management/product_management/domain/entities/entities.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get totalPrice => product.price * quantity;
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];
  final bool _isLoading = false;
  String? _errorMessage;

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

  void addToCart(Product product) {
    _errorMessage = null; // Clear error
    // Check if exists
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      if (_items[index].quantity + 1 > product.quantity) {
        _errorMessage = 'Cannot add more. Out of stock.';
      } else {
        _items[index].quantity++;
      }
    } else {
      if (product.quantity > 0) {
        _items.add(CartItem(product: product));
      } else {
        _errorMessage = 'Product is out of stock.';
      }
    }
    notifyListeners();
  }

  void updateQuantity(int productId, int quantity) {
    _errorMessage = null;
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (quantity > _items[index].product.quantity) {
        _errorMessage = 'Cannot add more. Max stock reached.';
      } else if (quantity <= 0) {
        removeFromCart(productId);
        return;
      } else {
        _items[index].quantity = quantity;
      }
      notifyListeners();
    }
  }

  void removeFromCart(int productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }
  
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}

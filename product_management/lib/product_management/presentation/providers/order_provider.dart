import 'package:flutter/material.dart';
import '../../domain/entities/entities.dart';
import '../../domain/usecases/usecases.dart';
import 'cart_provider.dart';

class OrderProvider extends ChangeNotifier {
  final GetOrdersUseCase _getOrdersUseCase;
  final UpdateOrderStatusUseCase _updateOrderStatusUseCase;
  final CreateOrderUseCase _createOrderUseCase;
  final GetOrdersByEmailUseCase _getOrdersByEmailUseCase;
  final CancelOrderUseCase _cancelOrderUseCase;

  OrderProvider(
    this._getOrdersUseCase,
    this._updateOrderStatusUseCase,
    this._createOrderUseCase,
    this._getOrdersByEmailUseCase,
    this._cancelOrderUseCase,
  );

  List<Order> _orders = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchOrders() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _orders = await _getOrdersUseCase();
      _orders.sort((a, b) => b.createdDate.compareTo(a.createdDate)); // Sort by date desc
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> fetchOrdersByEmail(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _orders = await _getOrdersByEmailUseCase(email);
      _orders.sort((a, b) => b.createdDate.compareTo(a.createdDate));
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<bool> updateOrderStatus(int id, String status) async {
    // Optimistic update or wait? Let's wait for safety
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _updateOrderStatusUseCase(id, status);
      await fetchOrders(); // Refresh list
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> cancelOrder(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _cancelOrderUseCase(id);
      
      // Optimistic update: Update local state immediately
      final index = _orders.indexWhere((o) => o.id == id);
      if (index != -1) {
        // We need to mutate the order. Since Order is final, create a copy?
        // Actually, simpler to just fetchOrders or hack it for now if Order is immutable.
        // Let's refetch to be safe and clean.
        await fetchOrders(); 
      }
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> createOrder({
    required String customerName,
    required String email,
    required String phone,
    required String address,
    required String paymentMethod,
    required List<CartItem> cartItems,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final orderItems = cartItems.map((item) => OrderItem(
        productId: item.product.id,
        productName: item.product.name,
        productImage: item.product.image,
        price: item.product.price,
        quantity: item.quantity,
      )).toList();

      final order = Order(
        id: 0, 
        orderCode: '', 
        customerName: customerName,
        email: email,
        phone: phone,
        address: address,
        paymentMethod: paymentMethod,
        totalPrice: cartItems.fold(0, (sum, item) => sum + item.totalPrice),
        status: 'pending',
        createdDate: DateTime.now(),
        items: orderItems,
      );

      await _createOrderUseCase(order);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}

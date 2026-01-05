import 'package:flutter/material.dart';
import 'package:product_management/features/orders/domain/entities/order_item_entity.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/usecases/get_orders_usecase.dart';
import '../../domain/usecases/get_order_by_id_usecase.dart';
import '../../domain/usecases/get_order_by_code_usecase.dart';
import '../../domain/usecases/get_orders_by_email_usecase.dart';
import '../../domain/usecases/get_orders_by_user_id_usecase.dart';
import '../../domain/usecases/get_orders_by_status_usecase.dart';
import '../../domain/usecases/create_order_usecase.dart';
import '../../domain/usecases/update_order_status_usecase.dart';
import '../../domain/usecases/cancel_order_usecase.dart';
import 'cart_provider.dart';

class OrderProvider extends ChangeNotifier {
  final GetOrdersUseCase _getOrdersUseCase;
  final GetOrderByIdUseCase _getOrderByIdUseCase;
  final GetOrderByCodeUseCase _getOrderByCodeUseCase;
  final GetOrdersByEmailUseCase _getOrdersByEmailUseCase;
  final GetOrdersByUserIdUseCase _getOrdersByUserIdUseCase;
  final GetOrdersByStatusUseCase _getOrdersByStatusUseCase;
  final UpdateOrderStatusUseCase _updateOrderStatusUseCase;
  final CreateOrderUseCase _createOrderUseCase;
  final CancelOrderUseCase _cancelOrderUseCase;

  OrderProvider(
    this._getOrdersUseCase,
    this._getOrderByIdUseCase,
    this._getOrderByCodeUseCase,
    this._getOrdersByEmailUseCase,
    this._getOrdersByUserIdUseCase,
    this._getOrdersByStatusUseCase,
    this._updateOrderStatusUseCase,
    this._createOrderUseCase,
    this._cancelOrderUseCase,
  );

  List<Order> _orders = [];
  List<Order> _userOrders = [];
  Order? _selectedOrder;
  bool _isLoading = false;
  String? _errorMessage;

  List<Order> get orders => _orders;
  List<Order> get userOrders => _userOrders;
  Order? get selectedOrder => _selectedOrder;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchOrders() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _orders = await _getOrdersUseCase();
      _orders.sort((a, b) => b.createdDate.compareTo(a.createdDate));
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<Order?> getOrderById(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _selectedOrder = await _getOrderByIdUseCase(id);
      _isLoading = false;
      notifyListeners();
      return _selectedOrder;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<void> fetchOrderById(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _selectedOrder = await _getOrderByIdUseCase(id);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<Order?> getOrderByCode(String code) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _selectedOrder = await _getOrderByCodeUseCase(code);
      _isLoading = false;
      notifyListeners();
      return _selectedOrder;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return null;
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

  Future<void> fetchOrdersByUserId(int userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _userOrders = await _getOrdersByUserIdUseCase(userId);
      _userOrders.sort((a, b) => b.createdDate.compareTo(a.createdDate));
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> fetchOrdersByStatus(String status) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _orders = await _getOrdersByStatusUseCase(status);
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
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _updateOrderStatusUseCase(id, status);
      await fetchOrders();
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
    int? userId,
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
        userId: userId,
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

  Future<bool> cancelOrder(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _cancelOrderUseCase(id);
      await fetchOrders();
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



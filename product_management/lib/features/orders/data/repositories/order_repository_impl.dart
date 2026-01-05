import '../../../../api/api_service.dart';
import '../models/order_model.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/order_item_entity.dart';
import '../../domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final ApiService _apiService;
  OrderRepositoryImpl(this._apiService);

  @override
  Future<List<Order>> getOrders() async {
    final models = await _apiService.fetchOrders();
    return models.map((m) => _toEntity(m)).toList();
  }

  @override
  Future<Order> getOrderById(int id) async {
    final model = await _apiService.getOrderById(id);
    return _toEntity(model);
  }

  @override
  Future<Order> getOrderByCode(String code) async {
    final model = await _apiService.getOrderByCode(code);
    return _toEntity(model);
  }

  @override
  Future<List<Order>> getOrdersByEmail(String email) async {
    final models = await _apiService.getOrdersByEmail(email);
    return models.map((m) => _toEntity(m)).toList();
  }

  @override
  Future<List<Order>> getOrdersByUserId(int userId) async {
    final models = await _apiService.getOrdersByUserId(userId);
    return models.map((m) => _toEntity(m)).toList();
  }

  @override
  Future<List<Order>> getOrdersByStatus(String status) async {
    final models = await _apiService.getOrdersByStatus(status);
    return models.map((m) => _toEntity(m)).toList();
  }

  @override
  Future<Order> createOrder(Order order) async {
    final modelOutput = await _apiService.createOrder(
      userId: order.userId,
      customerName: order.customerName,
      email: order.email ?? '',
      phone: order.phone ?? '',
      address: order.address ?? '',
      paymentMethod: order.paymentMethod ?? 'cash',
      items: order.items.map((i) => {
        'productId': i.productId,
        'quantity': i.quantity,
      }).toList(),
    );
    return _toEntity(modelOutput);
  }

  @override
  Future<void> updateOrderStatus(int id, String status) {
    return _apiService.updateOrderStatus(id, status);
  }

  @override
  Future<void> cancelOrder(int id) async {
    await _apiService.cancelOrder(id);
  }

  Order _toEntity(OrderModel model) {
    return Order(
      id: model.id,
      orderCode: model.orderCode,
      customerName: model.customerName,
      email: model.email,
      phone: model.phone,
      address: model.address,
      paymentMethod: model.paymentMethod,
      totalPrice: model.totalPrice,
      status: model.status,
      createdDate: model.createdDate,
      items: model.items.map((i) => OrderItem(
        productId: i.productId,
        productName: i.productName,
        productImage: i.productImage,
        price: i.price,
        quantity: i.quantity,
      )).toList(),
    );
  }
}



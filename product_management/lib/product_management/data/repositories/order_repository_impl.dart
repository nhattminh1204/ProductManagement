import '../../../../api/api_service.dart';
import '../../domain/entities/entities.dart';
import '../../domain/repositories/repositories.dart';
import '../../../../features/orders/data/models/order_model.dart';
import '../../../../features/orders/data/models/order_item_model.dart';

class OrderRepositoryImpl implements OrderRepository {
  final ApiService _apiService;
  OrderRepositoryImpl(this._apiService);

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

  @override
  Future<List<Order>> getOrders() async {
    final models = await _apiService.fetchOrders();
    return models.map(_toEntity).toList();
  }

  @override
  Future<List<Order>> getOrdersByEmail(String email) async {
    final models = await _apiService.getOrdersByEmail(email);
    return models.map(_toEntity).toList();
  }

  @override
  Future<void> updateOrderStatus(int id, String status) {
    return _apiService.updateOrderStatus(id, status);
  }

  @override
  Future<void> cancelOrder(int id) {
    return _apiService.cancelOrder(id);
  }

  @override
  Future<Order> createOrder(Order order) async {
    // Map items to JSON for API
    final itemsJson = order.items.map((i) => {
      'productId': i.productId,
      'productName': i.productName,
      'productImage': i.productImage,
      'price': i.price,
      'quantity': i.quantity,
    }).toList();

    final newModel = await _apiService.createOrder(
      customerName: order.customerName,
      email: order.email ?? '',
      phone: order.phone ?? '',
      address: order.address ?? '',
      paymentMethod: order.paymentMethod ?? 'COD',
      items: itemsJson,
    );
    return _toEntity(newModel);
  }
}

import '../entities/order_entity.dart';

abstract class OrderRepository {
  Future<List<Order>> getOrders();
  Future<Order> getOrderById(int id);
  Future<Order> getOrderByCode(String code);
  Future<List<Order>> getOrdersByEmail(String email);
  Future<Order> createOrder(Order order);
  Future<void> updateOrderStatus(int id, String status);
  Future<void> cancelOrder(int id);
}



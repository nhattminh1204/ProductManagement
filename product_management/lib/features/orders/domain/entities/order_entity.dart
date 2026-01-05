import 'order_item_entity.dart';

class Order {
  final int id;
  final String orderCode;
  final String customerName;
  final String? email;
  final String? phone;
  final String? address;
  final int? userId;
  final String? paymentMethod;
  final double totalPrice;
  final String status;
  final DateTime createdDate;
  final List<OrderItem> items;

  Order({
    required this.id,
    required this.orderCode,
    required this.customerName,
    this.email,
    this.phone,
    this.address,
    this.userId,
    this.paymentMethod,
    required this.totalPrice,
    required this.status,
    required this.createdDate,
    required this.items,
  });
}



import 'order_item_model.dart';

class OrderModel {
  final int id;
  final String orderCode;
  final String customerName;
  final String? email;
  final String? phone;
  final String? address;
  final String? paymentMethod;
  final double totalPrice;
  final String status; // pending, paid, shipped, cancelled
  final DateTime createdDate;
  final List<OrderItemModel> items;

  OrderModel({
    required this.id,
    required this.orderCode,
    required this.customerName,
    this.email,
    this.phone,
    this.address,
    this.paymentMethod,
    required this.totalPrice,
    required this.status,
    required this.createdDate,
    required this.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? 0,
      orderCode: json['orderCode'] ?? '',
      customerName: json['customerName'] ?? 'Guest',
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      paymentMethod: json['paymentMethod'],
      totalPrice: _parseDouble(json['totalAmount']) ?? _parseDouble(json['totalPrice']) ?? 0.0,
      status: json['status'] ?? 'pending',
      createdDate: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => OrderItemModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderCode': orderCode,
      'customerName': customerName,
      'email': email,
      'phone': phone,
      'address': address,
      'paymentMethod': paymentMethod,
      'totalPrice': totalPrice,
      'status': status,
      'createdDate': createdDate.toIso8601String(),
      'items': items.map((e) => e.toJson()).toList(),
    };
  }
}



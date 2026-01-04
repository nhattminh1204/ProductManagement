class OrderItem {
  final int productId;
  final String productName;
  final String? productImage;
  final double price;
  final int quantity;

  OrderItem({
    required this.productId,
    required this.productName,
    this.productImage,
    required this.price,
    required this.quantity,
  });
  
  // Helpers for calculations
  double get totalPrice => price * quantity;
}

class Order {
  final int id;
  final String orderCode;
  final String customerName;
  final String? email;
  final String? phone;
  final String? address;
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
    this.paymentMethod,
    required this.totalPrice,
    required this.status,
    required this.createdDate,
    required this.items,
  });
}

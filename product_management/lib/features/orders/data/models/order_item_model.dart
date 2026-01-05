class OrderItemModel {
  final int productId;
  final String productName;
  final String? productImage;
  final double price;
  final int quantity;

  OrderItemModel({
    required this.productId,
    required this.productName,
    this.productImage,
    required this.price,
    required this.quantity,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      productId: json['productId'] ?? 0,
      productName: json['productName'] ?? '',
      productImage: json['productImage'],
      price: _parseDouble(json['price']) ?? 0.0,
      quantity: json['quantity'] ?? 0,
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
      'productId': productId,
      'productName': productName,
      'productImage': productImage,
      'price': price,
      'quantity': quantity,
    };
  }
}



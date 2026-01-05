class PaymentModel {
  final int? id;
  final int orderId;
  final double amount;
  final String paymentMethod;
  final String status;
  final DateTime? paidAt;

  PaymentModel({
    this.id,
    required this.orderId,
    required this.amount,
    required this.paymentMethod,
    required this.status,
    this.paidAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'],
      orderId: json['orderId'],
      amount: (json['amount'] as num).toDouble(),
      paymentMethod: json['paymentMethod'] ?? '',
      status: json['status'] ?? 'pending',
      paidAt: json['paidAt'] != null ? DateTime.parse(json['paidAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
      'amount': amount,
      'paymentMethod': paymentMethod,
      'status': status,
      'paidAt': paidAt?.toIso8601String(),
    };
  }
}


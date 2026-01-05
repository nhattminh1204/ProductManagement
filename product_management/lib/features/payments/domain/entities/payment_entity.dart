class Payment {
  final int? id;
  final int orderId;
  final double amount;
  final String paymentMethod;
  final String status;
  final DateTime? paidAt;

  Payment({
    this.id,
    required this.orderId,
    required this.amount,
    required this.paymentMethod,
    required this.status,
    this.paidAt,
  });
}


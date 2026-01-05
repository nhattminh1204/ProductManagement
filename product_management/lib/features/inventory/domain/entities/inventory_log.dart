class InventoryLog {
  final int id;
  final int productId;
  final int changeQuantity;
  final String logType; // import, export, adjustment
  final String? notes;
  final DateTime createdAt;

  InventoryLog({
    required this.id,
    required this.productId,
    required this.changeQuantity,
    required this.logType,
    this.notes,
    required this.createdAt,
  });
}

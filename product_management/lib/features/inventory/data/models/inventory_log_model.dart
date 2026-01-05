import '../../domain/entities/inventory_log.dart';

class InventoryLogModel extends InventoryLog {
  InventoryLogModel({
    required super.id,
    required super.productId,
    required super.changeQuantity,
    required super.logType,
    super.notes,
    required super.createdAt,
  });

  factory InventoryLogModel.fromJson(Map<String, dynamic> json) {
    return InventoryLogModel(
      id: json['id'] ?? 0,
      productId: json['productId'] ?? 0,
      changeQuantity: json['changeQuantity'] ?? 0,
      logType: json['logType'] ?? 'adjustment',
      notes: json['notes'],
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'changeQuantity': changeQuantity,
      'logType': logType,
      'notes': notes,
    };
  }
}

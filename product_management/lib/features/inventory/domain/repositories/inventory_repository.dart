import '../entities/inventory_log.dart';

abstract class InventoryRepository {
  Future<List<InventoryLog>> getLogs();
  Future<List<InventoryLog>> getLogsByProduct(int productId);
  Future<void> createLog(int productId, int changeQuantity, String logType, String notes);
}

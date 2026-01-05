import '../../domain/repositories/inventory_repository.dart';
import '../../domain/entities/inventory_log.dart';
import '../../../../api/api_service.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  final ApiService apiService;

  InventoryRepositoryImpl(this.apiService);

  @override
  Future<List<InventoryLog>> getLogs() async {
    return await apiService.getInventoryLogs();
  }

  @override
  Future<List<InventoryLog>> getLogsByProduct(int productId) async {
    return await apiService.getInventoryLogsByProduct(productId);
  }

  @override
  Future<void> createLog(int productId, int changeQuantity, String logType, String notes) async {
    await apiService.createInventoryLog(productId, changeQuantity, logType, notes);
  }
}

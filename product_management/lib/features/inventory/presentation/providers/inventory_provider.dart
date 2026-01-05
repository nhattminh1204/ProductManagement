import 'package:flutter/material.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../../domain/entities/inventory_log.dart';

class InventoryProvider extends ChangeNotifier {
  final InventoryRepository repository;

  List<InventoryLog> _logs = [];
  List<InventoryLog> _productLogs = [];
  bool _isLoading = false;
  String? _errorMessage;

  InventoryProvider(this.repository);

  List<InventoryLog> get logs => _logs;
  List<InventoryLog> get productLogs => _productLogs;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchLogs() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _logs = await repository.getLogs();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchLogsByProduct(int productId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _productLogs = await repository.getLogsByProduct(productId);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createLog(
    int productId,
    int changeQuantity,
    String logType,
    String notes,
  ) async {
    try {
      await repository.createLog(productId, changeQuantity, logType, notes);
      await fetchLogs(); // Refresh list
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}

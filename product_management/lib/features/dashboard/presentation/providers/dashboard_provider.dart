import 'package:flutter/foundation.dart';
import '../../domain/entities/dashboard_stats_entity.dart';
import '../../domain/usecases/get_dashboard_stats_usecase.dart';
import '../../domain/usecases/get_revenue_by_period_usecase.dart';
import '../../domain/usecases/get_top_products_usecase.dart';
import '../../domain/usecases/get_order_stats_by_status_usecase.dart';

class DashboardProvider extends ChangeNotifier {
  final GetDashboardStatsUseCase getDashboardStatsUseCase;
  final GetRevenueByPeriodUseCase getRevenueByPeriodUseCase;
  final GetTopProductsUseCase getTopProductsUseCase;
  final GetOrderStatsByStatusUseCase getOrderStatsByStatusUseCase;

  DashboardProvider(
    this.getDashboardStatsUseCase,
    this.getRevenueByPeriodUseCase,
    this.getTopProductsUseCase,
    this.getOrderStatsByStatusUseCase,
  );

  DashboardStats? _stats;
  Map<String, double> _revenue = {};
  List<TopProduct> _topProducts = [];
  Map<String, int> _orderStatsByStatus = {};
  bool _isLoading = false;
  String? _error;

  DashboardStats? get stats => _stats;
  Map<String, double> get revenue => _revenue;
  List<TopProduct> get topProducts => _topProducts;
  Map<String, int> get orderStatsByStatus => _orderStatsByStatus;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchDashboardStats() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _stats = await getDashboardStatsUseCase.execute();
      _error = null;
    } catch (e) {
      _error = e.toString();
      _stats = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchRevenueByPeriod(String period) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _revenue = await getRevenueByPeriodUseCase.execute(period);
      _error = null;
    } catch (e) {
      _error = e.toString();
      _revenue = {};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchTopProducts(int? limit) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _topProducts = await getTopProductsUseCase.execute(limit);
      _error = null;
    } catch (e) {
      _error = e.toString();
      _topProducts = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchOrderStatsByStatus() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _orderStatsByStatus = await getOrderStatsByStatusUseCase.execute();
      _error = null;
    } catch (e) {
      _error = e.toString();
      _orderStatsByStatus = {};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}


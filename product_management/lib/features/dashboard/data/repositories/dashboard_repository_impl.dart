import '../../../../api/api_service.dart';
import '../models/dashboard_stats_model.dart';
import '../../domain/entities/dashboard_stats_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final ApiService _apiService;
  DashboardRepositoryImpl(this._apiService);

  @override
  Future<DashboardStats> getDashboardStats() async {
    final model = await _apiService.getDashboardStats();
    return _toEntity(model);
  }

  @override
  Future<Map<String, double>> getRevenueByPeriod(String period) async {
    return await _apiService.getRevenueByPeriod(period);
  }

  @override
  Future<List<TopProduct>> getTopProducts(int? limit) async {
    final models = await _apiService.getTopProducts(limit);
    return models.map((m) => TopProduct(
          productId: m.productId,
          productName: m.productName,
          totalSold: m.totalSold,
          totalRevenue: m.totalRevenue,
        )).toList();
  }

  @override
  Future<Map<String, int>> getOrderStatsByStatus() async {
    return await _apiService.getOrderStatsByStatus();
  }

  DashboardStats _toEntity(DashboardStatsModel model) {
    return DashboardStats(
      totalOrders: model.totalOrders,
      totalRevenue: model.totalRevenue,
      totalProducts: model.totalProducts,
      totalUsers: model.totalUsers,
      recentOrders: model.recentOrders,
      topProducts: model.topProducts.map((m) => TopProduct(
        productId: m.productId,
        productName: m.productName,
        totalSold: m.totalSold,
        totalRevenue: m.totalRevenue,
      )).toList(),
      orderStatsByStatus: model.orderStatsByStatus,
    );
  }
}


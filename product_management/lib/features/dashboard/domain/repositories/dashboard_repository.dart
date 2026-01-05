import '../entities/dashboard_stats_entity.dart';

abstract class DashboardRepository {
  Future<DashboardStats> getDashboardStats();
  Future<Map<String, double>> getRevenueByPeriod(String period);
  Future<List<TopProduct>> getTopProducts(int? limit);
  Future<Map<String, int>> getOrderStatsByStatus();
}


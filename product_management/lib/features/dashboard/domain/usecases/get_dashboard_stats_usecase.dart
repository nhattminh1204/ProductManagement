import '../entities/dashboard_stats_entity.dart';
import '../repositories/dashboard_repository.dart';

class GetDashboardStatsUseCase {
  final DashboardRepository repository;

  GetDashboardStatsUseCase(this.repository);

  Future<DashboardStats> execute() {
    return repository.getDashboardStats();
  }
}


import '../repositories/dashboard_repository.dart';

class GetOrderStatsByStatusUseCase {
  final DashboardRepository repository;

  GetOrderStatsByStatusUseCase(this.repository);

  Future<Map<String, int>> execute() {
    return repository.getOrderStatsByStatus();
  }
}



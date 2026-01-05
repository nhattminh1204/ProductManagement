import '../repositories/dashboard_repository.dart';

class GetRevenueByPeriodUseCase {
  final DashboardRepository repository;

  GetRevenueByPeriodUseCase(this.repository);

  Future<Map<String, double>> execute(String period) {
    return repository.getRevenueByPeriod(period);
  }
}


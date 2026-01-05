import '../entities/dashboard_stats_entity.dart';
import '../repositories/dashboard_repository.dart';

class GetTopProductsUseCase {
  final DashboardRepository repository;

  GetTopProductsUseCase(this.repository);

  Future<List<TopProduct>> execute(int? limit) {
    return repository.getTopProducts(limit);
  }
}


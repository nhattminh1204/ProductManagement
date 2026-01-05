import '../repositories/product_repository.dart';
import '../entities/product_entity.dart';

class GetLowStockProductsUseCase {
  final ProductRepository repository;
  GetLowStockProductsUseCase(this.repository);

  Future<List<Product>> call() {
    return repository.getLowStockProducts();
  }
}


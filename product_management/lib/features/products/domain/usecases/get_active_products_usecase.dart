import '../repositories/product_repository.dart';
import '../entities/product_entity.dart';

class GetActiveProductsUseCase {
  final ProductRepository repository;
  GetActiveProductsUseCase(this.repository);

  Future<List<Product>> call() {
    return repository.getActiveProducts();
  }
}



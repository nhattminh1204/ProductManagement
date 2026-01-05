import '../repositories/product_repository.dart';
import '../entities/product_entity.dart';

class GetFeaturedProductsUseCase {
  final ProductRepository repository;
  GetFeaturedProductsUseCase(this.repository);

  Future<List<Product>> call() {
    return repository.getFeaturedProducts();
  }
}


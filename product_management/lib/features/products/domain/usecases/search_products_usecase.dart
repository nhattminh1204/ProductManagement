import '../repositories/product_repository.dart';
import '../entities/product_entity.dart';

class SearchProductsUseCase {
  final ProductRepository repository;
  SearchProductsUseCase(this.repository);

  Future<List<Product>> call(String keyword) {
    return repository.searchProducts(keyword);
  }
}



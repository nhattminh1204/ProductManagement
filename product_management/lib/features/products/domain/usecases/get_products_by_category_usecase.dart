import '../repositories/product_repository.dart';
import '../entities/product_entity.dart';

class GetProductsByCategoryUseCase {
  final ProductRepository repository;
  GetProductsByCategoryUseCase(this.repository);

  Future<List<Product>> call(int categoryId) {
    return repository.getProductsByCategory(categoryId);
  }
}



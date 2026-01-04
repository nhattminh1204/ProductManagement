import '../repositories/product_repository.dart';
import '../entities/product_entity.dart';

class UpdateProductUseCase {
  final ProductRepository repository;
  UpdateProductUseCase(this.repository);

  Future<Product> call(int id, Product product) {
    return repository.updateProduct(id, product);
  }
}



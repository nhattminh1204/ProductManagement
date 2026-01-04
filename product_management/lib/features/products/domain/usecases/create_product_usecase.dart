import '../repositories/product_repository.dart';
import '../entities/product_entity.dart';

class CreateProductUseCase {
  final ProductRepository repository;
  CreateProductUseCase(this.repository);

  Future<Product> call(Product product) {
    return repository.createProduct(product);
  }
}



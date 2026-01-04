import '../repositories/product_repository.dart';
import '../entities/product_entity.dart';

class GetProductByIdUseCase {
  final ProductRepository repository;
  GetProductByIdUseCase(this.repository);

  Future<Product> call(int id) {
    return repository.getProductById(id);
  }
}



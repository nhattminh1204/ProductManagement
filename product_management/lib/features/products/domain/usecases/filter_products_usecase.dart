import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class FilterProductsUseCase {
  final ProductRepository repository;

  FilterProductsUseCase(this.repository);

  Future<List<Product>> call({
    String? keyword,
    int? categoryId,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    String? sortBy,
  }) {
    return repository.filterProducts(
      keyword: keyword,
      categoryId: categoryId,
      minPrice: minPrice,
      maxPrice: maxPrice,
      minRating: minRating,
      sortBy: sortBy,
    );
  }
}

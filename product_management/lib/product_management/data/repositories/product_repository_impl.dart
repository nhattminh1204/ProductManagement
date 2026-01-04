import '../../../../api/api_service.dart';
import '../../domain/entities/entities.dart';
import '../../domain/repositories/repositories.dart';
import '../../../../features/products/data/models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ApiService _apiService;
  ProductRepositoryImpl(this._apiService);

  Product _toEntity(ProductModel model) {
    return Product(
      id: model.id,
      name: model.name,
      image: model.image,
      price: model.price,
      quantity: model.quantity,
      status: model.status,
      categoryId: model.categoryId,
      categoryName: model.categoryName,
      averageRating: model.averageRating,
      totalRatings: model.totalRatings,
    );
  }

  ProductModel _toModel(Product entity) {
    return ProductModel(
      id: entity.id,
      name: entity.name,
      image: entity.image,
      price: entity.price,
      quantity: entity.quantity,
      status: entity.status,
      categoryId: entity.categoryId,
      categoryName: entity.categoryName,
      averageRating: entity.averageRating,
      totalRatings: entity.totalRatings,
    );
  }

  @override
  Future<List<Product>> getProducts() async {
    final models = await _apiService.fetchProducts();
    return models.map(_toEntity).toList();
  }

  @override
  Future<List<Product>> searchProducts(String keyword) async {
    final models = await _apiService.searchProducts(keyword);
    return models.map(_toEntity).toList();
  }

  @override
  Future<Product> createProduct(Product product) async {
    final model = _toModel(product);
    final newModel = await _apiService.createProduct(model);
    return _toEntity(newModel);
  }

  @override
  Future<Product> updateProduct(int id, Product product) async {
    final model = _toModel(product);
    final updatedModel = await _apiService.updateProduct(id, model);
    return _toEntity(updatedModel);
  }

  @override
  Future<void> deleteProduct(int id) {
    return _apiService.deleteProduct(id);
  }
}

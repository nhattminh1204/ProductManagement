import '../../../../api/api_service.dart';
import '../models/product_model.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ApiService _apiService;
  ProductRepositoryImpl(this._apiService);

  @override
  Future<List<Product>> getProducts() async {
    final models = await _apiService.fetchProducts();
    return models.map((m) => _toEntity(m)).toList();
  }

  @override
  Future<List<Product>> getActiveProducts() async {
    final models = await _apiService.fetchActiveProducts();
    return models.map((m) => _toEntity(m)).toList();
  }

  @override
  Future<Product> getProductById(int id) async {
    final model = await _apiService.getProductById(id);
    return _toEntity(model);
  }

  @override
  Future<List<Product>> getProductsByCategory(int categoryId) async {
    final models = await _apiService.getProductsByCategory(categoryId);
    return models.map((m) => _toEntity(m)).toList();
  }

  @override
  Future<List<Product>> searchProducts(String keyword) async {
    final models = await _apiService.searchProducts(keyword);
    return models.map((m) => _toEntity(m)).toList();
  }

  @override
  Future<List<Product>> filterProducts({
    String? keyword,
    int? categoryId,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    String? sortBy,
  }) async {
    final models = await _apiService.filterProducts(
      keyword: keyword,
      categoryId: categoryId,
      minPrice: minPrice,
      maxPrice: maxPrice,
      minRating: minRating,
      sortBy: sortBy,
    );
    return models.map((m) => _toEntity(m)).toList();
  }

  @override
  Future<List<Product>> getFeaturedProducts() async {
    final models = await _apiService.getFeaturedProducts();
    return models.map((m) => _toEntity(m)).toList();
  }

  @override
  Future<List<Product>> getLowStockProducts() async {
    final models = await _apiService.getLowStockProducts();
    return models.map((m) => _toEntity(m)).toList();
  }

  @override
  Future<Product> createProduct(Product product) async {
    final modelInput = _toModel(product);
    final modelOutput = await _apiService.createProduct(modelInput);
    return _toEntity(modelOutput);
  }
  
  @override
  Future<Product> updateProduct(int id, Product product) async {
     final modelInput = _toModel(product);
     final modelOutput = await _apiService.updateProduct(id, modelInput);
     return _toEntity(modelOutput);
  }

  @override
  Future<void> deleteProduct(int id) async {
    await _apiService.deleteProduct(id);
  }

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
      description: model.description,
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
      description: entity.description,
    );
  }
}



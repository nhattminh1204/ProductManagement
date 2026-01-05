import '../entities/product_entity.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();
  Future<List<Product>> getActiveProducts();
  Future<Product> getProductById(int id);
  Future<List<Product>> getProductsByCategory(int categoryId);
  Future<List<Product>> searchProducts(String keyword);
  Future<List<Product>> getFeaturedProducts();
  Future<List<Product>> getLowStockProducts();
  Future<Product> createProduct(Product product);
  Future<Product> updateProduct(int id, Product product);
  Future<void> deleteProduct(int id);
}



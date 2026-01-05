import 'package:product_management/product_management/domain/entities/entities.dart';

abstract class AuthRepository {
  Future<String> login(String usernameOrEmail, String password);
  Future<void> register(String name, String username, String email, String phone, String password);
}

abstract class ProductRepository {
  Future<List<Product>> getProducts();
  Future<List<Product>> searchProducts(String keyword);
  Future<Product> createProduct(Product product);
  Future<Product> updateProduct(int id, Product product);
  Future<void> deleteProduct(int id);
}

abstract class CategoryRepository {
  Future<List<Category>> getCategories();
  Future<List<Category>> getActiveCategories();
}

abstract class OrderRepository {
  Future<List<Order>> getOrders();
  Future<List<Order>> getOrdersByEmail(String email);
  Future<void> updateOrderStatus(int id, String status);
  Future<void> cancelOrder(int id);
  Future<Order> createOrder(Order order);
}

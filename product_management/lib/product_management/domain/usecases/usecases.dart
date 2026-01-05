import '../repositories/repositories.dart';
import '../entities/entities.dart';

// --- Auth ---
class LoginUseCase {
  final AuthRepository repository;
  LoginUseCase(this.repository);

  Future<String> call(String usernameOrEmail, String password) {
    return repository.login(usernameOrEmail, password);
  }
}

class RegisterUseCase {
  final AuthRepository repository;
  RegisterUseCase(this.repository);

  Future<void> call(
    String name,
    String username,
    String email,
    String phone,
    String password,
  ) {
    return repository.register(name, username, email, phone, password);
  }
}

// --- Product ---
class GetProductsUseCase {
  final ProductRepository repository;
  GetProductsUseCase(this.repository);

  Future<List<Product>> call() {
    return repository.getProducts();
  }
}

class SearchProductsUseCase {
  final ProductRepository repository;
  SearchProductsUseCase(this.repository);

  Future<List<Product>> call(String keyword) {
    return repository.searchProducts(keyword);
  }
}

class CreateProductUseCase {
  final ProductRepository repository;
  CreateProductUseCase(this.repository);

  Future<Product> call(Product product) {
    return repository.createProduct(product);
  }
}

class UpdateProductUseCase {
  final ProductRepository repository;
  UpdateProductUseCase(this.repository);

  Future<Product> call(int id, Product product) {
    return repository.updateProduct(id, product);
  }
}

class DeleteProductUseCase {
  final ProductRepository repository;
  DeleteProductUseCase(this.repository);

  Future<void> call(int id) {
    return repository.deleteProduct(id);
  }
}

// --- Category ---
class GetCategoriesUseCase {
  final CategoryRepository repository;
  GetCategoriesUseCase(this.repository);

  Future<List<Category>> call() {
    return repository.getCategories();
  }
}

class GetActiveCategoriesUseCase {
  final CategoryRepository repository;
  GetActiveCategoriesUseCase(this.repository);

  Future<List<Category>> call() {
    return repository.getActiveCategories();
  }
}

// --- Order ---
class GetOrdersUseCase {
  final OrderRepository repository;
  GetOrdersUseCase(this.repository);

  Future<List<Order>> call() {
    return repository.getOrders();
  }
}

class GetOrdersByEmailUseCase {
  final OrderRepository repository;
  GetOrdersByEmailUseCase(this.repository);

  Future<List<Order>> call(String email) {
    return repository.getOrdersByEmail(email);
  }
}

class UpdateOrderStatusUseCase {
  final OrderRepository repository;
  UpdateOrderStatusUseCase(this.repository);

  Future<void> call(int id, String status) {
    return repository.updateOrderStatus(id, status);
  }
}

class CreateOrderUseCase {
  final OrderRepository repository;
  CreateOrderUseCase(this.repository);

  Future<Order> call(Order order) {
    return repository.createOrder(order);
  }
}

class CancelOrderUseCase {
  final OrderRepository repository;
  CancelOrderUseCase(this.repository);

  Future<void> call(int id) {
    return repository.cancelOrder(id);
  }
}

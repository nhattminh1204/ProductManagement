import 'package:dio/dio.dart';
import 'package:product_management/features/dashboard/data/models/dashboard_stats_model.dart';
import '../features/products/data/models/product_model.dart';
import '../features/categories/data/models/category_model.dart';
import '../features/orders/data/models/order_model.dart';
import '../features/users/data/models/user_model.dart';
import '../features/ratings/data/models/rating_model.dart';
import '../product_management/data/models/cart_item_model.dart';
import '../features/wishlist/data/models/wishlist_model.dart';
import '../features/inventory/data/models/inventory_log_model.dart';
import '../features/payments/data/models/payment_model.dart';
import '../features/addresses/data/models/user_address_model.dart';

import '../core/config/app_config.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  late Dio _dio;
  String? _authToken;

  ApiService._internal() {
    BaseOptions options = BaseOptions(
      baseUrl: AppConfig.apiUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    );

    _dio = Dio(options);

    // Add interceptor to attach token
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_authToken != null) {
            options.headers['Authorization'] = 'Bearer $_authToken';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          // Handle global errors here if needed
          return handler.next(e);
        },
      ),
    );
  }

  void setToken(String token) {
    _authToken = token;
  }

  String _parseError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return 'Connection timeout. Please check your internet.';
    }
    if (e.response?.statusCode == 400) {
      return e.response?.data['message'] ?? 'Invalid request.';
    }
    if (e.response?.statusCode == 401) {
      return 'Unauthorized. Please login again.';
    }
    if (e.response?.statusCode == 403) {
      return 'Access denied. Admin privileges required.';
    }
    if (e.response?.statusCode == 404) {
      return 'Resource not found.';
    }
    if (e.response?.statusCode == 500) {
      return 'Server error. Please try again later.';
    }
    return 'An error occurred: ${e.message}';
  }

  // --- Auth ---
  Future<String> login(String usernameOrEmail, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'usernameOrEmail': usernameOrEmail, 'password': password},
      );
      if (response.data is Map) {
        final data = response.data['data'];
        if (data != null && data['token'] != null) {
          final token = data['token'];
          setToken(token);
          return token;
        }
      }
      throw Exception('Invalid response format: ${response.data}');
    } catch (e) {
      if (e is DioException) throw Exception(_parseError(e));
      rethrow;
    }
  }

  Future<void> register(
    String name,
    String username,
    String email,
    String phone,
    String password,
  ) async {
    try {
      await _dio.post(
        '/auth/register',
        data: {
          'name': name,
          'username': username,
          'email': email,
          'phone': phone,
          'password': password,
        },
      );
    } catch (e) {
      if (e is DioException) throw Exception(_parseError(e));
      rethrow;
    }
  }

  // --- Products ---
  Future<List<ProductModel>> fetchProducts() async {
    try {
      final response = await _dio.get('/products');
      final data = response.data['data'] as List;
      return data.map((e) => ProductModel.fromJson(e)).toList();
    } catch (e) {
      if (e is DioException) throw Exception(_parseError(e));
      rethrow;
    }
  }

  Future<List<ProductModel>> searchProducts(String keyword) async {
    try {
      final response = await _dio.get(
        '/products/search',
        queryParameters: {'keyword': keyword},
      );
      final data = response.data['data'] as List;
      return data.map((e) => ProductModel.fromJson(e)).toList();
    } catch (e) {
      if (e is DioException) throw Exception(_parseError(e));
      rethrow;
    }
  }

  Future<List<ProductModel>> filterProducts({
    String? keyword,
    int? categoryId,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    String? sortBy,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (keyword != null && keyword.isNotEmpty)
        queryParams['keyword'] = keyword;
      if (categoryId != null) queryParams['categoryId'] = categoryId;
      if (minPrice != null) queryParams['minPrice'] = minPrice;
      if (maxPrice != null) queryParams['maxPrice'] = maxPrice;
      if (minRating != null) queryParams['minRating'] = minRating;
      if (sortBy != null && sortBy.isNotEmpty) queryParams['sortBy'] = sortBy;

      final response = await _dio.get(
        '/products/filter',
        queryParameters: queryParams,
      );
      final data = response.data['data'] as List;
      return data.map((e) => ProductModel.fromJson(e)).toList();
    } catch (e) {
      if (e is DioException) throw Exception(_parseError(e));
      rethrow;
    }
  }

  Future<ProductModel> createProduct(ProductModel product) async {
    try {
      final response = await _dio.post('/products', data: product.toJson());
      return ProductModel.fromJson(response.data['data']);
    } catch (e) {
      if (e is DioException) throw Exception(_parseError(e));
      rethrow;
    }
  }

  Future<ProductModel> updateProduct(int id, ProductModel product) async {
    try {
      final response = await _dio.put('/products/$id', data: product.toJson());
      return ProductModel.fromJson(response.data['data']);
    } catch (e) {
      if (e is DioException) throw Exception(_parseError(e));
      rethrow;
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      await _dio.delete('/products/$id');
    } catch (e) {
      if (e is DioException) throw Exception(_parseError(e));
      rethrow;
    }
  }

  Future<List<ProductModel>> fetchActiveProducts() async {
    try {
      final response = await _dio.get('/products/active');
      final data = response.data['data'] as List;
      return data.map((e) => ProductModel.fromJson(e)).toList();
    } catch (e) {
      if (e is DioException) throw Exception(_parseError(e));
      rethrow;
    }
  }

  Future<ProductModel> getProductById(int id) async {
    try {
      final response = await _dio.get('/products/$id');
      return ProductModel.fromJson(response.data['data']);
    } catch (e) {
      if (e is DioException) throw Exception(_parseError(e));
      rethrow;
    }
  }

  Future<List<ProductModel>> getProductsByCategory(int categoryId) async {
    try {
      final response = await _dio.get('/products/category/$categoryId');
      final data = response.data['data'] as List;
      return data.map((e) => ProductModel.fromJson(e)).toList();
    } catch (e) {
      if (e is DioException) throw Exception(_parseError(e));
      rethrow;
    }
  }

  Future<List<ProductModel>> getFeaturedProducts() async {
    try {
      final response = await _dio.get('/products/featured');
      final data = response.data['data'] as List;
      return data.map((e) => ProductModel.fromJson(e)).toList();
    } catch (e) {
      if (e is DioException) throw Exception(_parseError(e));
      rethrow;
    }
  }

  Future<List<ProductModel>> getLowStockProducts() async {
    try {
      final response = await _dio.get('/products/low-stock');
      final data = response.data['data'] as List;
      return data.map((e) => ProductModel.fromJson(e)).toList();
    } catch (e) {
      if (e is DioException) throw Exception(_parseError(e));
      rethrow;
    }
  }

  // --- Categories ---
  Future<List<CategoryModel>> fetchCategories() async {
    try {
      final response = await _dio.get('/categories');
      final data = response.data['data'] as List;
      return data.map((e) => CategoryModel.fromJson(e)).toList();
    } catch (e) {
      if (e is DioException) throw Exception(_parseError(e));
      rethrow;
    }
  }

  Future<List<CategoryModel>> fetchActiveCategories() async {
    try {
      final response = await _dio.get('/categories/active');
      final data = response.data['data'] as List;
      return data.map((e) => CategoryModel.fromJson(e)).toList();
    } catch (e) {
      if (e is DioException) throw Exception(_parseError(e));
      rethrow;
    }
  }

  Future<CategoryModel> getCategoryById(int id) async {
    try {
      final response = await _dio.get('/categories/$id');
      return CategoryModel.fromJson(response.data['data']);
    } catch (e) {
      if (e is DioException) throw Exception(_parseError(e));
      rethrow;
    }
  }

  Future<CategoryModel> createCategory(CategoryModel category) async {
    try {
      final response = await _dio.post('/categories', data: category.toJson());
      return CategoryModel.fromJson(response.data['data']);
    } catch (e) {
      if (e is DioException) throw Exception(_parseError(e));
      rethrow;
    }
  }

  Future<CategoryModel> updateCategory(int id, CategoryModel category) async {
    try {
      final response = await _dio.put(
        '/categories/$id',
        data: category.toJson(),
      );
      return CategoryModel.fromJson(response.data['data']);
    } catch (e) {
      if (e is DioException) throw Exception(_parseError(e));
      rethrow;
    }
  }

  Future<void> deleteCategory(int id) async {
    try {
      await _dio.delete('/categories/$id');
    } catch (e) {
      if (e is DioException) throw Exception(_parseError(e));
      rethrow;
    }
  }

  // --- Orders ---
  Future<List<OrderModel>> fetchOrders() async {
    try {
      final response = await _dio.get('/orders');
      final data = response.data['data'] as List;
      return data.map((e) => OrderModel.fromJson(e)).toList();
    } catch (e) {
      if (e is DioException) throw Exception(_parseError(e));
      rethrow;
    }
  }

  Future<List<OrderModel>> getOrdersByEmail(String email) async {
    try {
      final response = await _dio.get('/orders/customer/$email');
      final data = response.data['data'] as List;
      return data.map((e) => OrderModel.fromJson(e)).toList();
    } catch (e) {
      if (e is DioException) throw Exception(_parseError(e));
      rethrow;
    }
  }

  Future<void> updateOrderStatus(int id, String status) async {
    try {
      await _dio.patch(
        '/orders/$id/status',
        queryParameters: {'status': status},
      );
    } catch (e) {
      if (e is DioException) throw Exception(_parseError(e));
      rethrow;
    }
  }

  Future<OrderModel> getOrderById(int id) async {
    try {
      final response = await _dio.get('/orders/$id');
      return OrderModel.fromJson(response.data['data']);
    } catch (e) {
      if (e is DioException) throw Exception(_parseError(e));
      rethrow;
    }
  }

  Future<OrderModel> getOrderByCode(String code) async {
    try {
      final response = await _dio.get('/orders/code/$code');
      return OrderModel.fromJson(response.data['data']);
    } catch (e) {
      if (e is DioException) throw Exception(_parseError(e));
      rethrow;
    }
  }

  Future<List<OrderModel>> getOrdersByUserId(int userId) async {
    try {
      final response = await _dio.get('/orders/user/$userId');
      final data = response.data['data'] as List;
      return data.map((e) => OrderModel.fromJson(e)).toList();
    } catch (e) {
      if (e is DioException) throw Exception(_parseError(e));
      rethrow;
    }
  }

  Future<List<OrderModel>> getOrdersByStatus(String status) async {
    try {
      final response = await _dio.get('/orders/status/$status');
      final data = response.data['data'] as List;
      return data.map((e) => OrderModel.fromJson(e)).toList();
    } catch (e) {
      if (e is DioException) throw Exception(_parseError(e));
      rethrow;
    }
  }

  Future<void> cancelOrder(int id) async {
    try {
      await _dio.delete('/orders/$id/cancel');
    } catch (e) {
      if (e is DioException) throw Exception(_parseError(e));
      rethrow;
    }
  }

  Future<OrderModel> createOrder({
    required int? userId,
    required String customerName,
    required String email,
    required String phone,
    required String address,
    required String paymentMethod,
    required List<Map<String, dynamic>> items,
  }) async {
    try {
      final response = await _dio.post(
        '/orders',
        data: {
          'userId': userId,
          'customerName': customerName,
          'email': email,
          'phone': phone,
          'address': address,
          'paymentMethod': paymentMethod,
          'items': items,
        },
      );
      return OrderModel.fromJson(response.data['data']);
    } catch (e) {
      if (e is DioException) throw Exception(_parseError(e));
      rethrow;
    }
  }

  // --- Users ---
  Future<List<UserModel>> fetchUsers() async {
    try {
      final response = await _dio.get('/users');
      final data = response.data['data'] as List;
      return data.map((e) => UserModel.fromJson(e)).toList();
    } catch (e) {
      if (e is DioException) throw Exception(_parseError(e));
      rethrow;
    }
  }

  Future<UserModel> getUserById(int id) async {
    try {
      final response = await _dio.get('/users/$id');
      return UserModel.fromJson(response.data['data']);
    } catch (e) {
      if (e is DioException) throw Exception(_parseError(e));
      rethrow;
    }
  }

  Future<UserModel> updateUser(int id, UserModel user) async {
    try {
      final response = await _dio.put('/users/$id', data: user.toJson());
      return UserModel.fromJson(response.data['data']);
    } catch (e) {
      if (e is DioException) throw Exception(_parseError(e));
      rethrow;
    }
  }

  Future<void> deleteUser(int id) async {
    try {
      await _dio.delete('/users/$id');
    } catch (e) {
      if (e is DioException) throw Exception(_parseError(e));
      rethrow;
    }
  }

  // --- Addresses ---
  Future<List<UserAddressModel>> getUserAddresses(int userId) async {
    try {
      final response = await _dio.get('/user-addresses/user/$userId');
      final data = response.data['data'] as List;
      return data.map((e) => UserAddressModel.fromJson(e)).toList();
    } catch (e) {
      if (e is DioException) throw Exception(_parseError(e));
      rethrow;
    }
  }

  Future<UserAddressModel> createAddress(UserAddressModel address) async {
    try {
      final response = await _dio.post('/user-addresses', data: address.toJson());
      return UserAddressModel.fromJson(response.data['data']);
    } catch (e) {
      if (e is DioException) throw Exception(_parseError(e));
      rethrow;
    }
  }

  Future<UserAddressModel> updateAddress(int id, UserAddressModel address) async {
    try {
      final response = await _dio.put('/user-addresses/$id', data: address.toJson());
      return UserAddressModel.fromJson(response.data['data']);
    } catch (e) {
      if (e is DioException) throw Exception(_parseError(e));
      rethrow;
    }
  }

  Future<void> deleteAddress(int id) async {
    try {
      await _dio.delete('/user-addresses/$id');
    } catch (e) {
      if (e is DioException) throw Exception(_parseError(e));
      rethrow;
    }
  }

  Future<void> changePassword(
      int userId, String oldPassword, String newPassword) async {
    try {
      await _dio.put(
        '/users/$userId/change-password',
        data: {'oldPassword': oldPassword, 'newPassword': newPassword},
      );
    } catch (e) {
      if (e is DioException) throw Exception(_parseError(e));
      rethrow;
    }
  }


  // --- Ratings ---
  Future<List<RatingModel>> getRatingsByProduct(int productId) async {
    try {
      final response = await _dio.get('/ratings/product/$productId');
      final data = response.data['data'] as List;
      return data.map((e) => RatingModel.fromJson(e)).toList();
    } catch (e) {
      if (e is DioException) throw Exception(_parseError(e));
      rethrow;
    }
  }

  Future<List<RatingModel>> getRatingsByUser(int userId) async {
    try {
      final response = await _dio.get('/ratings/user/$userId');
      final data = response.data['data'] as List;
      return data.map((e) => RatingModel.fromJson(e)).toList();
    } catch (e) {
      if (e is DioException) throw Exception(_parseError(e));
      rethrow;
    }
  }

  Future<RatingModel> createRating(RatingModel rating) async {
    try {
      final response = await _dio.post('/ratings', data: rating.toJson());
      return RatingModel.fromJson(response.data['data']);
    } catch (e) {
      if (e is DioException) throw Exception(_parseError(e));
      rethrow;
    }
  }

  Future<void> deleteRating(int id) async {
    try {
      await _dio.delete('/ratings/$id');
    } catch (e) {
      if (e is DioException) throw Exception(_parseError(e));
      rethrow;
    }
  }

  Future<List<RatingModel>> getAllRatings() async {
    try {
      final response = await _dio.get('/ratings');
      final data = response.data['data'] as List;
      return data.map((e) => RatingModel.fromJson(e)).toList();
    } catch (e) {
      if (e is DioException) throw Exception(_parseError(e));
      rethrow;
    }
  }

  // --- Cart ---
  Future<List<CartItemModel>> getCart(int userId) async {
    try {
      final response = await _dio.get('/cart/user/$userId');
      final data = response.data['data'] as List;
      return data.map((e) => CartItemModel.fromJson(e)).toList();
    } catch (e) {
      if (e is DioException) throw Exception(_parseError(e));
      rethrow;
    }
  }

  Future<CartItemModel> addToCart(
    int userId,
    int productId,
    int quantity,
  ) async {
    try {
      final response = await _dio.post(
        '/cart/user/$userId/add/$productId',
        queryParameters: {'quantity': quantity},
      );
      return CartItemModel.fromJson(response.data['data']);
    } catch (e) {
      if (e is DioException) throw Exception(_parseError(e));
      rethrow;
    }
  }

  Future<CartItemModel> updateCartItem(
    int userId,
    int productId,
    int quantity,
  ) async {
    try {
      final response = await _dio.put(
        '/cart/user/$userId/update/$productId',
        queryParameters: {'quantity': quantity},
      );
      return CartItemModel.fromJson(response.data['data']);
    } catch (e) {
      if (e is DioException) throw Exception(_parseError(e));
      rethrow;
    }
  }

  Future<void> removeFromCart(int userId, int productId) async {
    try {
      await _dio.delete('/cart/user/$userId/remove/$productId');
    } catch (e) {
      if (e is DioException) throw Exception(_parseError(e));
      rethrow;
    }
  }

  Future<void> clearCart(int userId) async {
    try {
      await _dio.delete('/cart/user/$userId/clear');
    } catch (e) {
      if (e is DioException) throw Exception(_parseError(e));
      rethrow;
    }
  }

  // --- Wishlist ---
  Future<List<WishlistModel>> getWishlist(int userId) async {
    try {
      final response = await _dio.get('/wishlists/user/$userId');
      final data = response.data['data'] as List;
      return data.map((e) => WishlistModel.fromJson(e)).toList();
    } catch (e) {
      if (e is DioException) throw Exception(_parseError(e));
      rethrow;
    }
  }

  Future<WishlistModel> addToWishlist(int userId, int productId) async {
    try {
      final response = await _dio.post('/wishlists/user/$userId/add/$productId');
      return WishlistModel.fromJson(response.data['data']);
    } catch (e) {
      if (e is DioException) throw Exception(_parseError(e));
      rethrow;
    }
  }

  Future<void> removeFromWishlist(int userId, int productId) async {
    try {
      await _dio.delete('/wishlists/user/$userId/remove/$productId');
    } catch (e) {
      if (e is DioException) throw Exception(_parseError(e));
      rethrow;
    }
  }

  // --- Inventory ---
  Future<List<InventoryLogModel>> getInventoryLogs() async {
    try {
      final response = await _dio.get('/inventory/logs');
      final data = response.data['data'] as List;
      return data.map((e) => InventoryLogModel.fromJson(e)).toList();
    } catch (e) {
      if (e is DioException) throw Exception(_parseError(e));
      rethrow;
    }
  }

  Future<void> createInventoryLog(
    int productId,
    int changeQuantity,
    String logType,
    String notes,
  ) async {
    try {
      await _dio.post(
        '/inventory/log',
        data: {
          'productId': productId,
          'changeQuantity': changeQuantity,
          'logType': logType,
          'notes': notes,
        },
      );
    } catch (e) {
      if (e is DioException) throw Exception(_parseError(e));
      rethrow;
    }
  }

  Future<List<InventoryLogModel>> getInventoryLogsByProduct(int productId) async {
    try {
      final response = await _dio.get('/inventory/product/$productId');
      final data = response.data['data'] as List;
      return data.map((e) => InventoryLogModel.fromJson(e)).toList();
    } catch (e) {
      if (e is DioException) throw Exception(_parseError(e));
      rethrow;
    }
  }

  // --- Payments ---
  Future<PaymentModel> createPayment(
    int orderId,
    double amount,
    String paymentMethod,
  ) async {
    try {
      final response = await _dio.post(
        '/payments',
        data: {
          'orderId': orderId,
          'amount': amount,
          'paymentMethod': paymentMethod,
          'status': 'pending',
        },
      );
      final data = response.data['data'];
      return PaymentModel.fromJson(data);
    } catch (e) {
      if (e is DioException) throw Exception(_parseError(e));
      rethrow;
    }
  }

  Future<PaymentModel> getPaymentById(int id) async {
    try {
      final response = await _dio.get('/payments/$id');
      final data = response.data['data'];
      return PaymentModel.fromJson(data);
    } catch (e) {
      if (e is DioException) throw Exception(_parseError(e));
      rethrow;
    }
  }

  Future<List<PaymentModel>> getPaymentsByOrderId(int orderId) async {
    try {
      final response = await _dio.get('/payments/order/$orderId');
      final data = response.data['data'] as List;
      return data.map((e) => PaymentModel.fromJson(e)).toList();
    } catch (e) {
      if (e is DioException) throw Exception(_parseError(e));
      rethrow;
    }
  }

  Future<List<PaymentModel>> getPaymentsByUserId(int userId) async {
    try {
      final response = await _dio.get('/payments/user/$userId');
      final data = response.data['data'] as List;
      return data.map((e) => PaymentModel.fromJson(e)).toList();
    } catch (e) {
      if (e is DioException) throw Exception(_parseError(e));
      rethrow;
    }
  }

  Future<List<PaymentModel>> getAllPayments() async {
    try {
      final response = await _dio.get('/payments');
      final data = response.data['data'] as List;
      return data.map((e) => PaymentModel.fromJson(e)).toList();
    } catch (e) {
      if (e is DioException) throw Exception(_parseError(e));
      rethrow;
    }
  }

  Future<PaymentModel> updatePaymentStatus(int id, String status) async {
    try {
      final response = await _dio.patch(
        '/payments/$id/status',
        queryParameters: {'status': status},
      );
      final data = response.data['data'];
      return PaymentModel.fromJson(data);
    } catch (e) {
      if (e is DioException) throw Exception(_parseError(e));
      rethrow;
    }
  }

  // --- Dashboard ---
  Future<DashboardStatsModel> getDashboardStats() async {
    try {
      final response = await _dio.get('/dashboard/stats');
      final data = response.data['data'];
      return DashboardStatsModel.fromJson(data);
    } catch (e) {
      if (e is DioException) throw Exception(_parseError(e));
      rethrow;
    }
  }

  Future<Map<String, double>> getRevenueByPeriod(String period) async {
    try {
      final response = await _dio.get(
        '/dashboard/revenue',
        queryParameters: {'period': period},
      );
      final data = response.data['data'] as Map<String, dynamic>;
      return data.map((key, value) => MapEntry(key, (value as num).toDouble()));
    } catch (e) {
      if (e is DioException) throw Exception(_parseError(e));
      rethrow;
    }
  }

  Future<List<TopProductModel>> getTopProducts(int? limit) async {
    try {
      final response = await _dio.get(
        '/dashboard/top-products',
        queryParameters: limit != null ? {'limit': limit} : null,
      );
      final data = response.data['data'] as List;
      return data.map((e) => TopProductModel.fromJson(e)).toList();
    } catch (e) {
      if (e is DioException) throw Exception(_parseError(e));
      rethrow;
    }
  }

  Future<Map<String, int>> getOrderStatsByStatus() async {
    try {
      final response = await _dio.get('/dashboard/order-stats');
      final data = response.data['data'] as Map<String, dynamic>;
      return data.map((key, value) => MapEntry(key, (value as num).toInt()));
    } catch (e) {
      if (e is DioException) throw Exception(_parseError(e));
      rethrow;
    }
  }
}

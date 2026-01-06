import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// API
import 'api/api_service.dart';

// Core
import 'core/config/app_config.dart';

// Repositories
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/products/data/repositories/product_repository_impl.dart';
import 'features/categories/data/repositories/category_repository_impl.dart';
import 'features/orders/data/repositories/order_repository_impl.dart';
import 'features/ratings/data/repositories/rating_repository_impl.dart';
import 'features/wishlist/data/repositories/wishlist_repository_impl.dart';
import 'features/inventory/data/repositories/inventory_repository_impl.dart';
import 'features/payments/data/repositories/payment_repository_impl.dart';
import 'features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'features/users/data/repositories/user_repository_impl.dart';
import 'features/addresses/data/repositories/user_address_repository_impl.dart';

// Auth Use Cases
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/register_usecase.dart';

// Product Use Cases
import 'features/products/domain/usecases/get_products_usecase.dart';
import 'features/products/domain/usecases/get_active_products_usecase.dart';
import 'features/products/domain/usecases/get_product_by_id_usecase.dart';
import 'features/products/domain/usecases/get_products_by_category_usecase.dart';
import 'features/products/domain/usecases/search_products_usecase.dart';
import 'features/products/domain/usecases/get_featured_products_usecase.dart';
import 'features/products/domain/usecases/get_low_stock_products_usecase.dart';
import 'features/products/domain/usecases/create_product_usecase.dart';
import 'features/products/domain/usecases/update_product_usecase.dart';
import 'features/products/domain/usecases/delete_product_usecase.dart';
import 'features/products/domain/usecases/filter_products_usecase.dart';

// Address Use Cases
import 'features/addresses/domain/usecases/address_usecases.dart';

// Category Use Cases
import 'features/categories/domain/usecases/get_categories_usecase.dart';
import 'features/categories/domain/usecases/get_active_categories_usecase.dart';
import 'features/categories/domain/usecases/get_category_by_id_usecase.dart';
import 'features/categories/domain/usecases/create_category_usecase.dart';
import 'features/categories/domain/usecases/update_category_usecase.dart';
import 'features/categories/domain/usecases/delete_category_usecase.dart';

// Order Use Cases
import 'features/orders/domain/usecases/get_orders_usecase.dart';
import 'features/orders/domain/usecases/get_order_by_id_usecase.dart';
import 'features/orders/domain/usecases/get_order_by_code_usecase.dart';
import 'features/orders/domain/usecases/get_orders_by_email_usecase.dart';
import 'features/orders/domain/usecases/get_orders_by_user_id_usecase.dart';
import 'features/orders/domain/usecases/get_orders_by_status_usecase.dart';
import 'features/orders/domain/usecases/create_order_usecase.dart';
import 'features/orders/domain/usecases/update_order_status_usecase.dart';
import 'features/orders/domain/usecases/cancel_order_usecase.dart';

// Rating Use Cases
import 'features/ratings/domain/usecases/get_ratings_by_product_usecase.dart';
import 'features/ratings/domain/usecases/get_ratings_by_user_usecase.dart';
import 'features/ratings/domain/usecases/create_rating_usecase.dart';
import 'features/ratings/domain/usecases/delete_rating_usecase.dart';

import 'features/ratings/domain/usecases/get_all_ratings_usecase.dart';

// Payment Use Cases
import 'features/payments/domain/usecases/create_payment_usecase.dart';

import 'features/payments/domain/usecases/get_payment_by_id_usecase.dart';
import 'features/payments/domain/usecases/get_payments_by_order_usecase.dart';
import 'features/payments/domain/usecases/get_payments_by_user_usecase.dart';
import 'features/payments/domain/usecases/update_payment_status_usecase.dart';

import 'features/payments/domain/usecases/get_all_payments_usecase.dart';

// Dashboard Use Cases
import 'features/dashboard/domain/usecases/get_dashboard_stats_usecase.dart';

import 'features/dashboard/domain/usecases/get_revenue_by_period_usecase.dart';
import 'features/dashboard/domain/usecases/get_top_products_usecase.dart';
import 'features/dashboard/domain/usecases/get_order_stats_by_status_usecase.dart';

// User Use Cases
import 'features/users/domain/usecases/get_users_usecase.dart';
import 'features/users/domain/usecases/get_user_by_id_usecase.dart';
import 'features/users/domain/usecases/update_user_usecase.dart';
import 'features/users/domain/usecases/delete_user_usecase.dart';

import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/products/presentation/providers/product_provider.dart';
import 'features/categories/presentation/providers/category_provider.dart';
import 'features/orders/presentation/providers/cart_provider.dart';
import 'features/orders/presentation/providers/order_provider.dart';
import 'features/ratings/presentation/providers/rating_provider.dart';
import 'features/wishlist/presentation/providers/wishlist_provider.dart';
import 'features/inventory/presentation/providers/inventory_provider.dart';
import 'features/payments/presentation/providers/payment_provider.dart';
import 'features/dashboard/presentation/providers/dashboard_provider.dart';
import 'features/users/presentation/providers/user_provider.dart';
import 'features/addresses/presentation/providers/user_address_provider.dart';

import 'product_management/presentation/design_system.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/shared/screens/user_main_screen.dart';
import 'features/shared/screens/admin_dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 0. Load Config
  await AppConfig.load();

  // 1. Initialize Service
  final apiService = ApiService();

  // 2. Initialize Repositories
  final authRepo = AuthRepositoryImpl(apiService);
  final productRepo = ProductRepositoryImpl(apiService);
  final categoryRepo = CategoryRepositoryImpl(apiService);
  final orderRepo = OrderRepositoryImpl(apiService);
  final ratingRepo = RatingRepositoryImpl(apiService);
  final wishlistRepo = WishlistRepositoryImpl(apiService);
  final inventoryRepo = InventoryRepositoryImpl(apiService);
  final paymentRepo = PaymentRepositoryImpl(apiService);
  final dashboardRepo = DashboardRepositoryImpl(apiService);
  final userRepo = UserRepositoryImpl(apiService);
  final addressRepo = UserAddressRepositoryImpl(apiService);

  // 3. Initialize Use Cases
  // Auth
  final loginUseCase = LoginUseCase(authRepo);
  final registerUseCase = RegisterUseCase(authRepo);

  // Product
  final getProductsUseCase = GetProductsUseCase(productRepo);
  final getActiveProductsUseCase = GetActiveProductsUseCase(productRepo);
  final getProductByIdUseCase = GetProductByIdUseCase(productRepo);
  final getProductsByCategoryUseCase = GetProductsByCategoryUseCase(productRepo);
  final searchProductsUseCase = SearchProductsUseCase(productRepo);
  final getFeaturedProductsUseCase = GetFeaturedProductsUseCase(productRepo);
  final getLowStockProductsUseCase = GetLowStockProductsUseCase(productRepo);
  final createProductUseCase = CreateProductUseCase(productRepo);
  final updateProductUseCase = UpdateProductUseCase(productRepo);
  final deleteProductUseCase = DeleteProductUseCase(productRepo);
  final filterProductsUseCase = FilterProductsUseCase(productRepo);

  // Address
  final getUserAddressesUseCase = GetUserAddressesUseCase(addressRepo);
  final createAddressUseCase = CreateAddressUseCase(addressRepo);
  final updateAddressUseCase = UpdateAddressUseCase(addressRepo);
  final deleteAddressUseCase = DeleteAddressUseCase(addressRepo);

  // Category
  final getCategoriesUseCase = GetCategoriesUseCase(categoryRepo);
  final getActiveCategoriesUseCase = GetActiveCategoriesUseCase(categoryRepo);
  final getCategoryByIdUseCase = GetCategoryByIdUseCase(categoryRepo);
  final createCategoryUseCase = CreateCategoryUseCase(categoryRepo);
  final updateCategoryUseCase = UpdateCategoryUseCase(categoryRepo);
  final deleteCategoryUseCase = DeleteCategoryUseCase(categoryRepo);

  // Order
  final getOrdersUseCase = GetOrdersUseCase(orderRepo);
  final getOrderByIdUseCase = GetOrderByIdUseCase(orderRepo);
  final getOrderByCodeUseCase = GetOrderByCodeUseCase(orderRepo);
  final getOrdersByEmailUseCase = GetOrdersByEmailUseCase(orderRepo);
  final getOrdersByUserIdUseCase = GetOrdersByUserIdUseCase(orderRepo);
  final getOrdersByStatusUseCase = GetOrdersByStatusUseCase(orderRepo);
  final updateOrderStatusUseCase = UpdateOrderStatusUseCase(orderRepo);
  final createOrderUseCase = CreateOrderUseCase(orderRepo);
  final cancelOrderUseCase = CancelOrderUseCase(orderRepo);

  // Rating
  final getRatingsByProductUseCase = GetRatingsByProductUseCase(ratingRepo);
  final getRatingsByUserUseCase = GetRatingsByUserUseCase(ratingRepo);
  final createRatingUseCase = CreateRatingUseCase(ratingRepo);
  final deleteRatingUseCase = DeleteRatingUseCase(ratingRepo);
  final getAllRatingsUseCase = GetAllRatingsUseCase(ratingRepo);

  // Payment
  final createPaymentUseCase = CreatePaymentUseCase(paymentRepo);
  final getPaymentByIdUseCase = GetPaymentByIdUseCase(paymentRepo);
  final getPaymentsByOrderUseCase = GetPaymentsByOrderUseCase(paymentRepo);
  final getPaymentsByUserUseCase = GetPaymentsByUserUseCase(paymentRepo);
  final updatePaymentStatusUseCase = UpdatePaymentStatusUseCase(paymentRepo);
  final getAllPaymentsUseCase = GetAllPaymentsUseCase(paymentRepo);

  // Dashboard
  final getDashboardStatsUseCase = GetDashboardStatsUseCase(dashboardRepo);
  final getRevenueByPeriodUseCase = GetRevenueByPeriodUseCase(dashboardRepo);
  final getTopProductsUseCase = GetTopProductsUseCase(dashboardRepo);
  final getOrderStatsByStatusUseCase = GetOrderStatsByStatusUseCase(dashboardRepo);

  // User
  final getUsersUseCase = GetUsersUseCase(userRepo);
  final getUserByIdUseCase = GetUserByIdUseCase(userRepo);
  final updateUserUseCase = UpdateUserUseCase(userRepo);
  final deleteUserUseCase = DeleteUserUseCase(userRepo);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) =>
              AuthProvider(loginUseCase, registerUseCase)..checkLoginStatus(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProductProvider(
            getProductsUseCase,
            getActiveProductsUseCase,
            getProductByIdUseCase,
            getProductsByCategoryUseCase,
            searchProductsUseCase,
            filterProductsUseCase,
            getFeaturedProductsUseCase,
            getLowStockProductsUseCase,
            createProductUseCase,
            updateProductUseCase,
            deleteProductUseCase,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => CategoryProvider(
            getCategoriesUseCase,
            getActiveCategoriesUseCase,
            getCategoryByIdUseCase,
            createCategoryUseCase,
            updateCategoryUseCase,
            deleteCategoryUseCase,
          ),
        ),
        ChangeNotifierProxyProvider<AuthProvider, CartProvider>(
          create: (_) => CartProvider(apiService: apiService),
          update: (_, auth, cart) =>
              (cart ?? CartProvider(apiService: apiService))..updateAuthProvider(auth),
        ),
        ChangeNotifierProvider(
          create: (_) => OrderProvider(
            getOrdersUseCase,
            getOrderByIdUseCase,
            getOrderByCodeUseCase,
            getOrdersByEmailUseCase,
            getOrdersByUserIdUseCase,
            getOrdersByStatusUseCase,
            updateOrderStatusUseCase,
            createOrderUseCase,
            cancelOrderUseCase,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => RatingProvider(
            getRatingsByProductUseCase,
            getRatingsByUserUseCase,
            getAllRatingsUseCase,
            createRatingUseCase,
            deleteRatingUseCase,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => WishlistProvider(wishlistRepo),
        ),
        ChangeNotifierProvider(
          create: (_) => InventoryProvider(inventoryRepo),
        ),
        ChangeNotifierProvider(
          create: (_) => PaymentProvider(
            createPaymentUseCase,
            getPaymentByIdUseCase,
            getPaymentsByOrderUseCase,
            getPaymentsByUserUseCase,
            updatePaymentStatusUseCase,
            getAllPaymentsUseCase,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => DashboardProvider(
            getDashboardStatsUseCase,
            getRevenueByPeriodUseCase,
            getTopProductsUseCase,
            getOrderStatsByStatusUseCase,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => UserProvider(
            getUsersUseCase,
            getUserByIdUseCase,
            updateUserUseCase,
            deleteUserUseCase,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => UserAddressProvider(
            getUserAddressesUseCase,
            createAddressUseCase,
            updateAddressUseCase,
            deleteAddressUseCase,
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Management',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          if (!auth.isAuthenticated) {
            return const LoginScreen();
          }
          if (auth.isAdmin) {
            return const AdminDashboardScreen();
          }
          return const UserMainScreen();
        },
      ),
    );
  }
}

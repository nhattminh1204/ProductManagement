import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// API
import 'api/api_service.dart';

// Core
import 'core/config/app_config.dart';

// Product Management Module
import 'product_management/data/repositories/auth_repository_impl.dart';
import 'product_management/data/repositories/product_repository_impl.dart';
import 'product_management/data/repositories/category_repository_impl.dart';
import 'product_management/data/repositories/order_repository_impl.dart';

import 'product_management/domain/usecases/usecases.dart';

import 'product_management/presentation/providers/auth_provider.dart';
import 'product_management/presentation/providers/product_provider.dart';
import 'product_management/presentation/providers/category_provider.dart';
import 'product_management/presentation/providers/cart_provider.dart';
import 'product_management/presentation/providers/order_provider.dart';
import 'product_management/presentation/providers/rating_provider.dart';
import 'product_management/data/repositories/rating_repository_impl.dart';

import 'product_management/presentation/design_system.dart';
import 'product_management/presentation/screens/login_screen.dart';
import 'product_management/presentation/screens/admin_dashboard_screen.dart';
import 'product_management/presentation/screens/user_main_screen.dart';

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

  // 3. Initialize Use Cases
  // Auth
  final loginUseCase = LoginUseCase(authRepo);
  final registerUseCase = RegisterUseCase(authRepo);

  // Product
  final getProductsUseCase = GetProductsUseCase(productRepo);
  final searchProductsUseCase = SearchProductsUseCase(productRepo);
  final createProductUseCase = CreateProductUseCase(productRepo);
  final updateProductUseCase = UpdateProductUseCase(productRepo);
  final deleteProductUseCase = DeleteProductUseCase(productRepo);

  // Category
  final getCategoriesUseCase = GetCategoriesUseCase(categoryRepo);
  final getActiveCategoriesUseCase = GetActiveCategoriesUseCase(categoryRepo);

  // Order
  final getOrdersUseCase = GetOrdersUseCase(orderRepo);
  final getOrdersByEmailUseCase = GetOrdersByEmailUseCase(orderRepo);
  final updateOrderStatusUseCase = UpdateOrderStatusUseCase(orderRepo);
  final createOrderUseCase = CreateOrderUseCase(orderRepo);

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
            searchProductsUseCase,
            createProductUseCase,
            updateProductUseCase,
            deleteProductUseCase,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => CategoryProvider(
            getCategoriesUseCase,
            getActiveCategoriesUseCase,
          ),
        ),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(
          create: (_) => OrderProvider(
            getOrdersUseCase,
            updateOrderStatusUseCase,
            createOrderUseCase,
            getOrdersByEmailUseCase,
            CancelOrderUseCase(orderRepo),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => RatingProvider(RatingRepositoryImpl(apiService)),
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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          error: AppColors.error,
          surface: AppColors.surface,
        ),
        scaffoldBackgroundColor: AppColors.background,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
            TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
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

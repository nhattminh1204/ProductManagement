import 'package:flutter/material.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../domain/usecases/get_active_products_usecase.dart';
import '../../domain/usecases/get_product_by_id_usecase.dart';
import '../../domain/usecases/get_products_by_category_usecase.dart';
import '../../domain/usecases/search_products_usecase.dart';
import '../../domain/usecases/get_featured_products_usecase.dart';
import '../../domain/usecases/get_low_stock_products_usecase.dart';
import '../../domain/usecases/create_product_usecase.dart';
import '../../domain/usecases/update_product_usecase.dart';
import '../../domain/usecases/delete_product_usecase.dart';

class ProductProvider extends ChangeNotifier {
  final GetProductsUseCase _getProductsUseCase;
  final GetActiveProductsUseCase _getActiveProductsUseCase;
  final GetProductByIdUseCase _getProductByIdUseCase;
  final GetProductsByCategoryUseCase _getProductsByCategoryUseCase;
  final SearchProductsUseCase _searchProductsUseCase;
  final GetFeaturedProductsUseCase _getFeaturedProductsUseCase;
  final GetLowStockProductsUseCase _getLowStockProductsUseCase;
  final CreateProductUseCase _createProductUseCase;
  final UpdateProductUseCase _updateProductUseCase;
  final DeleteProductUseCase _deleteProductUseCase;

  ProductProvider(
    this._getProductsUseCase,
    this._getActiveProductsUseCase,
    this._getProductByIdUseCase,
    this._getProductsByCategoryUseCase,
    this._searchProductsUseCase,
    this._getFeaturedProductsUseCase,
    this._getLowStockProductsUseCase,
    this._createProductUseCase,
    this._updateProductUseCase,
    this._deleteProductUseCase,
  );

  List<Product> _products = [];
  List<Product> _featuredProducts = [];
  List<Product> _lowStockProducts = [];
  Product? _selectedProduct;
  bool _isLoading = false;
  String? _errorMessage;

  List<Product> get products => _products;
  List<Product> get featuredProducts => _featuredProducts;
  List<Product> get lowStockProducts => _lowStockProducts;
  Product? get selectedProduct => _selectedProduct;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _products = await _getProductsUseCase();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> fetchActiveProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _products = await _getActiveProductsUseCase();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<Product?> getProductById(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _selectedProduct = await _getProductByIdUseCase(id);
      _isLoading = false;
      notifyListeners();
      return _selectedProduct;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<void> getProductsByCategory(int categoryId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _products = await _getProductsByCategoryUseCase(categoryId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> fetchProductsByCategory(int categoryId) async {
    await getProductsByCategory(categoryId);
  }

  Future<void> searchProducts(String keyword) async {
    if (keyword.isEmpty) {
      return fetchProducts();
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _products = await _searchProductsUseCase(keyword);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> fetchFeaturedProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _featuredProducts = await _getFeaturedProductsUseCase();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> fetchLowStockProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _lowStockProducts = await _getLowStockProductsUseCase();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<bool> createProduct(Product product) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _createProductUseCase(product);
      await fetchProducts(); 
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProduct(int id, Product product) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _updateProductUseCase(id, product);
      await fetchProducts();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteProduct(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _deleteProductUseCase(id);
      await fetchProducts();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}



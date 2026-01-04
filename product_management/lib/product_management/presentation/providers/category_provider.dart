import 'package:flutter/material.dart';
import '../../domain/entities/entities.dart';
import '../../domain/usecases/usecases.dart';

class CategoryProvider extends ChangeNotifier {
  final GetCategoriesUseCase _getCategoriesUseCase;
  final GetActiveCategoriesUseCase _getActiveCategoriesUseCase;

  CategoryProvider(
    this._getCategoriesUseCase,
    this._getActiveCategoriesUseCase,
  );

  List<Category> _categories = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchCategories() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _categories = await _getCategoriesUseCase();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> fetchActiveCategories() async {
     _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _categories = await _getActiveCategoriesUseCase();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}

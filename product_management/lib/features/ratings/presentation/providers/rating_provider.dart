import 'package:flutter/material.dart';
import '../../domain/entities/rating_entity.dart';
import '../../domain/usecases/get_ratings_by_product_usecase.dart';
import '../../domain/usecases/get_ratings_by_user_usecase.dart';
import '../../domain/usecases/create_rating_usecase.dart';
import '../../domain/usecases/delete_rating_usecase.dart';

class RatingProvider extends ChangeNotifier {
  final GetRatingsByProductUseCase _getRatingsByProductUseCase;
  final GetRatingsByUserUseCase _getRatingsByUserUseCase;
  final CreateRatingUseCase _createRatingUseCase;
  final DeleteRatingUseCase _deleteRatingUseCase;

  RatingProvider(
    this._getRatingsByProductUseCase,
    this._getRatingsByUserUseCase,
    this._createRatingUseCase,
    this._deleteRatingUseCase,
  );

  List<Rating> _ratings = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Rating> get ratings => _ratings;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchRatingsByProduct(int productId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _ratings = await _getRatingsByProductUseCase(productId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> fetchRatingsByUser(int userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _ratings = await _getRatingsByUserUseCase(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<bool> createRating(Rating rating) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _createRatingUseCase(rating);
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

  Future<bool> deleteRating(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _deleteRatingUseCase(id);
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



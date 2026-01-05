import 'package:flutter/material.dart';
import '../../domain/entities/rating_entity.dart';
import '../../domain/usecases/get_ratings_by_product_usecase.dart';
import '../../domain/usecases/get_ratings_by_user_usecase.dart';
import '../../domain/usecases/create_rating_usecase.dart';
import '../../domain/usecases/delete_rating_usecase.dart';

import '../../domain/usecases/get_all_ratings_usecase.dart';

class RatingProvider extends ChangeNotifier {
  final GetRatingsByProductUseCase _getRatingsByProductUseCase;
  final GetRatingsByUserUseCase _getRatingsByUserUseCase;
  final GetAllRatingsUseCase _getAllRatingsUseCase;
  final CreateRatingUseCase _createRatingUseCase;
  final DeleteRatingUseCase _deleteRatingUseCase;

  RatingProvider(
    this._getRatingsByProductUseCase,
    this._getRatingsByUserUseCase,
    this._getAllRatingsUseCase,
    this._createRatingUseCase,
    this._deleteRatingUseCase,
  );

  List<Rating> _ratings = [];
  List<Rating> _allRatings = []; // Store all ratings for filtering
  bool _isLoading = false;
  String? _errorMessage;

  // Filter state
  int? _filterStars;
  DateTime? _filterDate;
  String? _searchQuery;

  List<Rating> get ratings => _ratings;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Getters for filter state
  int? get filterStars => _filterStars;
  DateTime? get filterDate => _filterDate;
  String? get searchQuery => _searchQuery;

  Future<void> fetchAllRatings() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _allRatings = await _getAllRatingsUseCase();
      _applyFilters();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  void setFilters({
    int? stars,
    DateTime? date,
    String? query,
  }) {
    _filterStars = stars;
    _filterDate = date;
    if (query != null) {
      _searchQuery = query;
    }
    _applyFilters();
    notifyListeners();
  }

  void clearFilters() {
    _filterStars = null;
    _filterDate = null;
    _searchQuery = null;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _ratings = _allRatings.where((rating) {
      // Star filter
      if (_filterStars != null && rating.rating != _filterStars) {
        return false;
      }

      // Date filter
      if (_filterDate != null) {
        final ratingDate = DateTime(
          rating.createdDate.year,
          rating.createdDate.month,
          rating.createdDate.day,
        );
        final filterDate = DateTime(
          _filterDate!.year,
          _filterDate!.month,
          _filterDate!.day,
        );
        if (ratingDate != filterDate) {
          return false;
        }
      }

      // Search query (Product Name, User Name)
      if (_searchQuery != null && _searchQuery!.isNotEmpty) {
        final query = _searchQuery!.toLowerCase();
        final matchesProduct = rating.productName?.toLowerCase().contains(query) ?? false;
        final matchesUser = rating.userName?.toLowerCase().contains(query) ?? false;
        
        if (!matchesProduct && !matchesUser) {
          return false;
        }
      }

      return true;
    }).toList();
    
    // Sort by date desc
    _ratings.sort((a, b) => b.createdDate.compareTo(a.createdDate));
  }


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



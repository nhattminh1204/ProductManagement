import 'package:flutter/material.dart';
import '../../domain/entities/entities.dart';
import '../../domain/repositories/rating_repository.dart';

class RatingProvider extends ChangeNotifier {
  final RatingRepository _repository;

  RatingProvider(this._repository);

  List<Rating> _ratings = [];
  List<Rating> get ratings => _ratings;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchRatingsByProduct(int productId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _ratings = await _repository.getRatingsByProduct(productId);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addRating(Rating rating) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newRating = await _repository.createRating(rating);
      _ratings.insert(0, newRating); // Add to top
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

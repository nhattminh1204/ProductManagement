import '../../../../api/api_service.dart';
import '../models/rating_model.dart';
import '../../domain/entities/rating_entity.dart';
import '../../domain/repositories/rating_repository.dart';

class RatingRepositoryImpl implements RatingRepository {
  final ApiService _apiService;
  RatingRepositoryImpl(this._apiService);

  @override
  Future<List<Rating>> getRatingsByProduct(int productId) async {
    final models = await _apiService.getRatingsByProduct(productId);
    return models.map((m) => _toEntity(m)).toList();
  }

  @override
  Future<List<Rating>> getRatingsByUser(int userId) async {
    final models = await _apiService.getRatingsByUser(userId);
    return models.map((m) => _toEntity(m)).toList();
  }

  @override
  Future<Rating> createRating(Rating rating) async {
    final modelInput = _toModel(rating);
    final modelOutput = await _apiService.createRating(modelInput);
    return _toEntity(modelOutput);
  }

  @override
  Future<void> deleteRating(int id) async {
    await _apiService.deleteRating(id);
  }

  Rating _toEntity(RatingModel model) {
    return Rating(
      id: model.id,
      productId: model.productId,
      userId: model.userId,
      rating: model.rating,
      comment: model.comment,
      createdDate: model.createdDate,
      userName: model.userName,
      productName: model.productName,
    );
  }

  RatingModel _toModel(Rating entity) {
    return RatingModel(
      id: entity.id,
      productId: entity.productId,
      userId: entity.userId,
      rating: entity.rating,
      comment: entity.comment,
      createdDate: entity.createdDate,
      userName: entity.userName,
      productName: entity.productName,
    );
  }
}



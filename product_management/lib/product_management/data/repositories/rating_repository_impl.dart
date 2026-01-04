import '../../../../api/api_service.dart';
import '../../domain/entities/entities.dart';
import '../../domain/repositories/rating_repository.dart';
import '../../../../features/ratings/data/models/rating_model.dart';

class RatingRepositoryImpl implements RatingRepository {
  final ApiService _apiService;

  RatingRepositoryImpl(this._apiService);

  @override
  Future<List<Rating>> getRatingsByProduct(int productId) async {
    final models = await _apiService.getRatingsByProduct(productId);
    return models
        .map(
          (m) => Rating(
            id: m.id,
            productId: m.productId,
            userId: m.userId,
            rating: m.rating,
            comment: m.comment,
            createdAt: m.createdDate,
            userName: m.userName,
          ),
        )
        .toList();
  }

  @override
  Future<Rating> createRating(Rating rating) async {
    final model = RatingModel(
      id: rating.id ?? 0,
      productId: rating.productId,
      userId: rating.userId,
      rating: rating.rating,
      comment: rating.comment,
      createdDate: rating.createdAt ?? DateTime.now(),
      userName: rating.userName,
    );
    final newModel = await _apiService.createRating(model);
    return Rating(
      id: newModel.id,
      productId: newModel.productId,
      userId: newModel.userId,
      rating: newModel.rating,
      comment: newModel.comment,
      createdAt: newModel.createdDate,
      userName: newModel.userName,
    );
  }
}

import '../entities/rating_entity.dart';

abstract class RatingRepository {
  Future<List<Rating>> getAllRatings();
  Future<List<Rating>> getRatingsByProduct(int productId);
  Future<List<Rating>> getRatingsByUser(int userId);
  Future<Rating> createRating(Rating rating);
  Future<void> deleteRating(int id);
}



import '../entities/rating.dart';

abstract class RatingRepository {
  Future<List<Rating>> getRatingsByProduct(int productId);
  Future<Rating> createRating(Rating rating);
}

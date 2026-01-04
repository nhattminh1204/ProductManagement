import '../repositories/rating_repository.dart';
import '../entities/rating_entity.dart';

class GetRatingsByProductUseCase {
  final RatingRepository repository;
  GetRatingsByProductUseCase(this.repository);

  Future<List<Rating>> call(int productId) {
    return repository.getRatingsByProduct(productId);
  }
}



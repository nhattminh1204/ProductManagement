import '../repositories/rating_repository.dart';
import '../entities/rating_entity.dart';

class GetRatingsByUserUseCase {
  final RatingRepository repository;
  GetRatingsByUserUseCase(this.repository);

  Future<List<Rating>> call(int userId) {
    return repository.getRatingsByUser(userId);
  }
}



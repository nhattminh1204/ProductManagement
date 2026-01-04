import '../repositories/rating_repository.dart';
import '../entities/rating_entity.dart';

class CreateRatingUseCase {
  final RatingRepository repository;
  CreateRatingUseCase(this.repository);

  Future<Rating> call(Rating rating) {
    return repository.createRating(rating);
  }
}



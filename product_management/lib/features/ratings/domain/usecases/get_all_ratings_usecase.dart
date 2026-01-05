import '../entities/rating_entity.dart';
import '../repositories/rating_repository.dart';

class GetAllRatingsUseCase {
  final RatingRepository repository;

  GetAllRatingsUseCase(this.repository);

  Future<List<Rating>> call() {
    return repository.getAllRatings();
  }
}

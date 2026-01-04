import '../repositories/rating_repository.dart';

class DeleteRatingUseCase {
  final RatingRepository repository;
  DeleteRatingUseCase(this.repository);

  Future<void> call(int id) {
    return repository.deleteRating(id);
  }
}



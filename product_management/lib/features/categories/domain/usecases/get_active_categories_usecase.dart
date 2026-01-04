import '../repositories/category_repository.dart';
import '../entities/category_entity.dart';

class GetActiveCategoriesUseCase {
  final CategoryRepository repository;
  GetActiveCategoriesUseCase(this.repository);

  Future<List<Category>> call() {
    return repository.getActiveCategories();
  }
}



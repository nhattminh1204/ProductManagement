import '../repositories/category_repository.dart';
import '../entities/category_entity.dart';

class CreateCategoryUseCase {
  final CategoryRepository repository;
  CreateCategoryUseCase(this.repository);

  Future<Category> call(Category category) {
    return repository.createCategory(category);
  }
}



import '../repositories/category_repository.dart';
import '../entities/category_entity.dart';

class UpdateCategoryUseCase {
  final CategoryRepository repository;
  UpdateCategoryUseCase(this.repository);

  Future<Category> call(int id, Category category) {
    return repository.updateCategory(id, category);
  }
}



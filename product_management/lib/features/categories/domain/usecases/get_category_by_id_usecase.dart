import '../repositories/category_repository.dart';
import '../entities/category_entity.dart';

class GetCategoryByIdUseCase {
  final CategoryRepository repository;
  GetCategoryByIdUseCase(this.repository);

  Future<Category> call(int id) {
    return repository.getCategoryById(id);
  }
}



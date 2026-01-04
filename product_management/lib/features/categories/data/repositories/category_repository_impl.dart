import '../../../../api/api_service.dart';
import '../models/category_model.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final ApiService _apiService;
  CategoryRepositoryImpl(this._apiService);

  @override
  Future<List<Category>> getCategories() async {
    final models = await _apiService.fetchCategories();
    return models.map((m) => _toEntity(m)).toList();
  }
  
  @override
  Future<List<Category>> getActiveCategories() async {
    final models = await _apiService.fetchActiveCategories();
    return models.map((m) => _toEntity(m)).toList();
  }

  @override
  Future<Category> getCategoryById(int id) async {
    final model = await _apiService.getCategoryById(id);
    return _toEntity(model);
  }

  @override
  Future<Category> createCategory(Category category) async {
    final modelInput = _toModel(category);
    final modelOutput = await _apiService.createCategory(modelInput);
    return _toEntity(modelOutput);
  }

  @override
  Future<Category> updateCategory(int id, Category category) async {
    final modelInput = _toModel(category);
    final modelOutput = await _apiService.updateCategory(id, modelInput);
    return _toEntity(modelOutput);
  }

  @override
  Future<void> deleteCategory(int id) async {
    await _apiService.deleteCategory(id);
  }

  Category _toEntity(CategoryModel model) {
    return Category(
      id: model.id,
      name: model.name,
      status: model.status,
    );
  }

  CategoryModel _toModel(Category entity) {
    return CategoryModel(
      id: entity.id,
      name: entity.name,
      status: entity.status,
    );
  }
}



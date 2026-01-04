import '../../../../api/api_service.dart';
import '../../domain/entities/entities.dart';
import '../../domain/repositories/repositories.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final ApiService _apiService;
  CategoryRepositoryImpl(this._apiService);

  @override
  Future<List<Category>> getCategories() async {
    final models = await _apiService.fetchCategories();
    return models
        .map((m) => Category(id: m.id, name: m.name, status: m.status))
        .toList();
  }

  @override
  Future<List<Category>> getActiveCategories() async {
    final models = await _apiService.fetchActiveCategories();
    return models
        .map((m) => Category(id: m.id, name: m.name, status: m.status))
        .toList();
  }
}

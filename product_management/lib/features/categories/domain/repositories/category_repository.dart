import '../entities/category_entity.dart';

abstract class CategoryRepository {
  Future<List<Category>> getCategories();
  Future<List<Category>> getActiveCategories();
  Future<Category> getCategoryById(int id);
  Future<Category> createCategory(Category category);
  Future<Category> updateCategory(int id, Category category);
  Future<void> deleteCategory(int id);
}



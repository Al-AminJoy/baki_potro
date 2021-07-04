import 'package:baki_potro/models/category.dart';
import 'package:baki_potro/repository/repository.dart';

class CategoryService {
  Repository _repository;

  CategoryService() {
    _repository = Repository();
  }

  saveCategory(Category category) async {
    return await _repository.insertData('categories', category.categoryMap());
  }

  readCategory() async {
    return await _repository.readData('categories');
  }

  readCategoryByID(categoryId) async {
    return await _repository.readDatById(
        'categories', 'category_id', categoryId);
  }

  updateCategory(Category category) async {
    return await _repository.update(
        'categories', 'category_id', category.categoryMap());
  }

  deleteCategory(categoryId) async {
    return await _repository.deleteDatById(
        'categories', 'category_id', categoryId);
  }
}

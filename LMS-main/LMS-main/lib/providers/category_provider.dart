import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/catagory_service.dart';

class CategoryProvider with ChangeNotifier {
  final CategoryApiService _service = CategoryApiService(); // optional service

  List<Category> _categories = [];
  bool _isLoading = false;

  List<Category> get categories => List.unmodifiable(_categories);
  bool get isLoading => _isLoading;
  Future<void> fetchCategories() async {
    _isLoading = true;
    notifyListeners();
    try {
      _categories = await _service.fetchCategories();
    } catch (e) {
      debugPrint("Error fetching categories: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void addCategory(Category category) {
    _categories.add(category);
    notifyListeners();
  }

  void updateCategory(Category category) {
    final index = _categories.indexWhere((c) => c.id == category.id);
    if (index != -1) {
      _categories[index] = category;
      notifyListeners();
    }
  }

  void deleteCategory(String categoryId) {
    _categories.removeWhere((c) => c.id == categoryId);
    notifyListeners();
  }

  Category? getCategoryById(String id) {
    try {
      return _categories.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }
}

import 'dart:convert';
import 'package:course_management_system/models/category.dart';
import 'package:http/http.dart' as http;
class CategoryApiService {
  final String baseUrl = 'http://16.170.31.99:8000';
  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/categories/'));
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }
  Future<Category> createCategory(String name, String description) async {
    final response = await http.post(
      Uri.parse('$baseUrl/categories/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'description': description}),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Category.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create category');
    }
  }
  Future<Category> updateCategory(
      int id, String name, String description) async {
    final response = await http.put(
      Uri.parse('$baseUrl/categories/$id/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'description': description}),
    );

    if (response.statusCode == 200) {
      return Category.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update category');
    }
  }

  Future<void> deleteCategory(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/categories/$id/'));
    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception('Failed to delete category');
    }
  }
}

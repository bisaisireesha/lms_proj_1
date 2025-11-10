import 'dart:convert';
import 'package:http/http.dart' as http;
// Import the User model (adjust the path as needed)
import '../models/user.dart';

class ApiService {
  final String baseUrl = 'http://16.170.31.99:8000';
  Future<User> createUser({
    required String name,
    required String email,
    required String password,
    int roleId = 0,
  }) async {
    final url = Uri.parse('$baseUrl/users'); // Adjust endpoint for creating user
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'role_id': roleId,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create user: ${response.body}');
    }
  }

  // Fetch all users
  Future<List<User>> getUsers() async {
    final url = Uri.parse('$baseUrl/users');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch users');
    }
  }
  Future<User> addUser(User user) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": user.name,
        "email": user.email,
        "role": user.role.name,
        "inactive": !user.isActive,
      }),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return User.fromMap(jsonDecode(response.body));
    } else {
      throw Exception("Failed to add user: ${response.body}");
    }
  }

  Future<User> updateUser(User user) async {
    final response = await http.put(
      Uri.parse("$baseUrl/${user.id}"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": user.name,
        "email": user.email,
        "role": user.role.name,
        "inactive": !user.isActive,
      }),
    );

    if (response.statusCode == 200) {
      return User.fromMap(jsonDecode(response.body));
    } else {
      throw Exception("Failed to update user: ${response.body}");
    }
  }

  Future<void> deleteUser(String id) async {
    final response = await http.delete(Uri.parse("$baseUrl/$id"));
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception("Failed to delete user (${response.statusCode})");
    }
  }
}

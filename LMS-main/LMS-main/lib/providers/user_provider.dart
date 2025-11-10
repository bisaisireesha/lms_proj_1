import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../services/user_api_service.dart';

class UserProvider with ChangeNotifier {
  final ApiService _api = ApiService();
  List<User> _users = [];
  bool _isLoading = false;

  List<User> get users => _users;
  bool get isLoading => _isLoading;

  Future<void> fetchUsers() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await http.get(Uri.parse('${_api.baseUrl}/users'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _users = data.map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch users: ${response.statusCode}');
      }
    } catch (e) {
      _users = [];
      debugPrint("Error fetching users: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addUser(User user) async {
    try {
      final newUser = await _api.addUser(user);
      _users.add(newUser);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUser(User user) async {
    try {
      final updated = await _api.updateUser(user);
      final index = _users.indexWhere((u) => u.id == user.id);
      if (index != -1) _users[index] = updated;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteUser(String id) async {
    try {
      await _api.deleteUser(id);
      _users.removeWhere((u) => u.id == id);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}

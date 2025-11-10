import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/progress.dart';
class UserProgressApiService {
  static const String baseUrl = 'http://16.170.31.99:8000';

  static Future<List<UserProgress>> fetchUserProgress(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl?user_id=$userId'));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => UserProgress.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load user progress');
    }
  }

  static Future<UserProgress> addOrUpdateProgress(UserProgress progress) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(progress.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return UserProgress.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update progress');
    }
  }

  static Future<void> deleteProgress(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete progress');
    }
  }
}

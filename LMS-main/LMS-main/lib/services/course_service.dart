import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/course.dart';

class CourseService {
  final String baseUrl = 'http://16.170.31.99:8000';

  // ✅ Get all courses
  Future<List<Course>> getCourses() async {
    final response = await http.get(Uri.parse('$baseUrl/courses/'));

    if (response.statusCode == 200) {
      return Course.fromList(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch courses');
    }
  }

  // ✅ Get single course by ID
  Future<Course> getCourseById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/courses/$id/'));

    if (response.statusCode == 200) {
      return Course.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Course not found');
    }
  }

  // ✅ Create course
  Future<Course> createCourse(Course course) async {
    final response = await http.post(
      Uri.parse('$baseUrl/courses/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(course.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return Course.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create course');
    }
  }

  // ✅ Update course
  Future<Course> updateCourse(int id, Course course) async {
    final response = await http.put(
      Uri.parse('$baseUrl/courses/$id/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(course.toJson()),
    );

    if (response.statusCode == 200) {
      return Course.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update course');
    }
  }

  // ✅ Delete course
  Future<void> deleteCourse(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/courses/$id/'));

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete course');
    }
  }
}

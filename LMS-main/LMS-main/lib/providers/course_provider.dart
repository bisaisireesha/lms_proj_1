import 'package:flutter/material.dart';
import '../models/course.dart';
import '../services/course_service.dart';

class CourseProvider with ChangeNotifier {
  final CourseService _service = CourseService();

  List<Course> _courses = [];
  bool _isLoading = false;

  List<Course> get courses => _courses;
  bool get isLoading => _isLoading;

  Future<void> fetchCourses() async {
    _isLoading = true;
    notifyListeners();
    try {
      _courses = await _service.getCourses();
    } catch (e) {
      debugPrint('Error fetching courses: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addCourse(Course course) async {
    try {
      final newCourse = await _service.createCourse(course);
      _courses.add(newCourse);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding course: $e');
      rethrow;
    }
  }

  Future<void> updateCourse(int id, Course course) async {
    try {
      final updated = await _service.updateCourse(id, course);
      final index = _courses.indexWhere((c) => c.id == id);
      if (index != -1) {
        _courses[index] = updated;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating course: $e');
      rethrow;
    }
  }

  Future<void> deleteCourse(int id) async {
    try {
      await _service.deleteCourse(id);
      _courses.removeWhere((c) => c.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting course: $e');
      rethrow;
    }
  }
}

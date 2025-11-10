import 'package:flutter/material.dart';
import '../../providers/course_provider.dart';
import '../../services/enroll_api_service.dart';
import 'package:provider/provider.dart';

class CourseEnrollmentScreen extends StatefulWidget {
  final int userId;
  const CourseEnrollmentScreen({super.key, required this.userId});
  @override
  State<CourseEnrollmentScreen> createState() => _CourseEnrollmentScreenState();
}

class _CourseEnrollmentScreenState extends State<CourseEnrollmentScreen> {
  bool _isLoading = false;
  final ApiService _apiService = ApiService();

  Future<void> _enroll(int courseId) async {
    setState(() => _isLoading = true);
    try {
      await _apiService.enrollUserInCourse(widget.userId, courseId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enrollment successful')),
      );
      // Optionally update local state or providers for enrolled courses here
    } catch (e) {
      // Log full error to help debugging and show a clearer message to the user
      final fullError = e is Exception ? e.toString() : e.toString();
      // Print to console / debug output
      // ignore: avoid_print
      print('Enroll error: $fullError');

      final message = fullError.replaceFirst('Exception: ', '');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Enrollment failed: $message')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final courseProvider = Provider.of<CourseProvider>(context);
    final courses = courseProvider.courses;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enroll in Courses'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];
                return ListTile(
                  title: Text(course.title),
                  subtitle: Text(course.instructor),
                  trailing: ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () => _enroll(int.parse(course.id.toString())),
                    child: _isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('Enroll'),
                  ),
                );
              },
            ),
    );
  }
}

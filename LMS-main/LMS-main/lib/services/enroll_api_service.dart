import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://16.170.31.99:8000'; // Replace with your backend URL

  /// Enroll a user in a course.
  /// Optionally pass an Authorization token if your endpoint requires it.
  Future<void> enrollUserInCourse(int userId, int courseId, {String? token}) async {
    final url = Uri.parse('$baseUrl/enrollments');

    try {
      final response = await http
          .post(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'user_id': userId,
          'course_id': courseId,
        }),
      )
          .timeout(const Duration(seconds: 20));

      if (response.statusCode == 200 || response.statusCode == 201) {
        // success
        return;
      }

      // Try to extract message from server response
      String serverMessage;
      try {
        final map = jsonDecode(response.body) as Map<String, dynamic>;
        serverMessage = (map['message'] ?? map['detail'] ?? map['error'] ?? response.body).toString();
      } catch (_) {
        serverMessage = response.body;
      }

      throw Exception('Enrollment failed (${response.statusCode}): $serverMessage');
    } on TimeoutException {
      throw Exception('Request timed out. Check your internet connection.');
    } on SocketException {
      throw Exception('No internet connection. Please check your network.');
    } catch (e) {
      throw Exception('Enrollment error: $e');
    }
  }
}

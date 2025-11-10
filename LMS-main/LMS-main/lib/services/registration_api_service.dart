import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://16.170.31.99:8000';

  Future<Map<String, dynamic>> register(String name, String email, int roleId, String password) async {
    final url = Uri.parse('$baseUrl/auth/register'); // Adjust endpoint path as per your backend
    
    final body = jsonEncode({
      "name": name,
      "email": email,
      "role_id": roleId,
      "password": password,
    });

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return jsonDecode(response.body); // Return parsed JSON response as Map
    } else {
      // Log server response body for debugging
      print('Registration failed with status: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Registration failed');
    }
  }
}

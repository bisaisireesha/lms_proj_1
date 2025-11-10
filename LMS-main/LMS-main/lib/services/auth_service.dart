import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'http://16.170.31.99:8000';

  /// Login method: returns full response map including token & user
  Future<Map<String, dynamic>> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');

    try {
      final resp = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        },
        body: {
          'grant_type': 'password',
          'username': username,
          'password': password,
          'scope': '',
          'client_id': 'string',
          'client_secret': '',
        },
      ).timeout(const Duration(seconds: 20));

      if (resp.statusCode == 200) {
        final map = jsonDecode(resp.body) as Map<String, dynamic>;
        return map; // contains access_token + user details
      } else if (resp.statusCode == 401) {
        throw Exception('Incorrect email or password');
      } else {
        throw Exception('Login failed (${resp.statusCode}): ${resp.body}');
      }
    } on TimeoutException {
      throw Exception('Request timed out. Check your internet connection.');
    } catch (e) {
      throw Exception('Login error: $e');
    }
  }

  /// Fetch user info using token (if needed)
  Future<Map<String, dynamic>> getMe(String token) async {
    final url = Uri.parse('$baseUrl/auth/me');

    try {
      final resp = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 20));

      if (resp.statusCode == 200) {
        return jsonDecode(resp.body) as Map<String, dynamic>;
      } else {
        throw Exception(
            'Failed to fetch user (${resp.statusCode}): ${resp.body}');
      }
    } on TimeoutException {
      throw Exception('Request timed out. Check your internet connection.');
    } catch (e) {
      throw Exception('Error fetching user info: $e');
    }
  }
}

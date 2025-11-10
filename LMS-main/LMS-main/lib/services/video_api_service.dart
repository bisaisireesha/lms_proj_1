import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/video.dart';

class VideoApiService {
  final String baseUrl = 'http://16.170.31.99:8000/api/videos';

  Future<List<Video>> fetchVideosByCourse(int courseId) async {
    final response = await http.get(Uri.parse('$baseUrl?course_id=$courseId'));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => Video.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load videos');
    }
  }

  Future<Video> createVideo(Video video) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(video.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return Video.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create video');
    }
  }

  Future<Video> updateVideo(Video video) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${video.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(video.toJson()),
    );

    if (response.statusCode == 200) {
      return Video.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update video');
    }
  }

  Future<void> deleteVideo(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete video');
    }
  }
}

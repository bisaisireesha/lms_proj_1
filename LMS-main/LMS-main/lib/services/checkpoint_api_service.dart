// services/checkpoint_api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/checkpoint.dart';

class CheckpointApiService {
  static const String baseUrl = "http://yourapi.com/api/checkpoints";

  // GET all checkpoints
  static Future<List<Checkpoint>> getCheckpoints() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => Checkpoint.fromJson(json)).toList();
    } else {
      throw Exception("Failed to fetch checkpoints");
    }
  }

  // POST add new checkpoint
  static Future<Checkpoint> addCheckpoint(Checkpoint checkpoint) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(checkpoint.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return Checkpoint.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to add checkpoint");
    }
  }

  // PUT update checkpoint
  static Future<Checkpoint> updateCheckpoint(Checkpoint checkpoint) async {
    final url = "$baseUrl/${checkpoint.id}";
    final response = await http.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(checkpoint.toJson()),
    );

    if (response.statusCode == 200) {
      return Checkpoint.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to update checkpoint");
    }
  }

  // DELETE checkpoint
  static Future<void> deleteCheckpoint(int id) async {
    final url = "$baseUrl/$id";
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception("Failed to delete checkpoint");
    }
  }
}

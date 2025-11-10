import 'package:flutter/material.dart';
import '../models/video.dart';
import '../services/video_api_service.dart';

class VideoProvider with ChangeNotifier {
  final VideoApiService _apiService = VideoApiService();

  List<Video> _videos = [];
  bool _isLoading = false;

  List<Video> get videos => List.unmodifiable(_videos);
  bool get isLoading => _isLoading;

  /// Fetch all videos for a course
  Future<void> loadVideosByCourse(int courseId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _videos = await _apiService.fetchVideosByCourse(courseId);
    } catch (e) {
      debugPrint('Error loading videos: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Add new video
  Future<void> addVideo(Video video) async {
    try {
      final newVideo = await _apiService.createVideo(video);
      _videos.add(newVideo);
      notifyListeners(); // 🔹 UI auto-updates
    } catch (e) {
      debugPrint('Error adding video: $e');
      rethrow;
    }
  }

  /// Update video
  Future<void> updateVideo(Video video) async {
    try {
      final updatedVideo = await _apiService.updateVideo(video);
      final index = _videos.indexWhere((v) => v.id == video.id);
      if (index != -1) {
        _videos[index] = updatedVideo;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating video: $e');
      rethrow;
    }
  }

  /// Delete video
  Future<void> deleteVideo(int id) async {
    try {
      await _apiService.deleteVideo(id);
      _videos.removeWhere((v) => v.id == id);
      notifyListeners(); // 🔹 UI auto-updates
    } catch (e) {
      debugPrint('Error deleting video: $e');
      rethrow;
    }
  }

  /// Filter by course
  List<Video> getVideosByCourse(int courseId) {
    return _videos.where((v) => v.courseId == courseId).toList();
  }
}

import 'package:flutter/material.dart';
import '../models/progress.dart';
import '../services/progress_api_service.dart';
import '../models/video.dart';

class UserProgressProvider with ChangeNotifier {
  List<UserProgress> _progressList = [];

  List<UserProgress> get progressList => _progressList;

  Future<void> fetchUserProgress(int userId) async {
    _progressList = await UserProgressApiService.fetchUserProgress(userId);
    notifyListeners();
  }

  Future<void> addOrUpdateProgress(UserProgress progress) async {
    final updated = await UserProgressApiService.addOrUpdateProgress(progress);
    final index = _progressList.indexWhere((p) => p.id == updated.id);
    if (index >= 0) {
      _progressList[index] = updated;
    } else {
      _progressList.add(updated);
    }
    notifyListeners();
  }

  Future<void> deleteProgress(int id) async {
    await UserProgressApiService.deleteProgress(id);
    _progressList.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  /// Calculate progress percentage for a course
  double getCourseProgress(int courseId, List<Video> courseVideos) {
    if (courseVideos.isEmpty) return 0.0;

    final progress = _progressList.firstWhere(
      (p) => p.courseId == courseId,
      orElse: () => UserProgress(
          id: 0,
          userId: 0,
          courseId: courseId,
          watchedMinutes: 0,
          progressPercentage: 0,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now()),
    );

    return progress.progressPercentage;
  }
}

// providers/checkpoints_provider.dart
import 'package:flutter/material.dart';
import '../models/checkpoint.dart';
import '../services/checkpoint_api_service.dart';

class CheckpointsProvider extends ChangeNotifier {
  List<Checkpoint> _checkpoints = [];

  List<Checkpoint> get checkpoints => _checkpoints;

  // Fetch all checkpoints
  Future<void> fetchCheckpoints() async {
    try {
      _checkpoints = await CheckpointApiService.getCheckpoints();
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching checkpoints: $e");
      rethrow;
    }
  }

  // Add checkpoint
  Future<void> addCheckpoint(Checkpoint checkpoint) async {
    try {
      final newCheckpoint = await CheckpointApiService.addCheckpoint(checkpoint);
      _checkpoints.add(newCheckpoint);
      notifyListeners();
    } catch (e) {
      debugPrint("Error adding checkpoint: $e");
      rethrow;
    }
  }

  // Update checkpoint
  Future<void> updateCheckpoint(Checkpoint checkpoint) async {
    try {
      final updatedCheckpoint = await CheckpointApiService.updateCheckpoint(checkpoint);
      final index = _checkpoints.indexWhere((c) => c.id == checkpoint.id);
      if (index >= 0) {
        _checkpoints[index] = updatedCheckpoint;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error updating checkpoint: $e");
      rethrow;
    }
  }

  // Delete checkpoint
  Future<void> deleteCheckpoint(int id) async {
    try {
      await CheckpointApiService.deleteCheckpoint(id);
      _checkpoints.removeWhere((c) => c.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint("Error deleting checkpoint: $e");
      rethrow;
    }
  }

  // Get checkpoints by video
  List<Checkpoint> getCheckpointsByVideo(int videoId) {
    return _checkpoints.where((c) => c.videoId == videoId).toList();
  }
}

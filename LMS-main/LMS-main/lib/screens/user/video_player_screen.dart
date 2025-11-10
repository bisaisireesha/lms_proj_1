import 'dart:async';
import 'package:course_management_system/screens/user/user_checkpoints.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/course.dart';
import '../../models/video.dart';
import '../../models/checkpoint.dart';
import '../../providers/video_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/checkpoints_provider.dart';
import '../../providers/user_progress_provider.dart';
import '../../models/progress.dart';

class UserVideoScreen extends StatefulWidget {
  final Course course;
  final List<Video> videos;

  const UserVideoScreen({
    Key? key,
    required this.course,
    required this.videos,
  }) : super(key: key);

  @override
  _UserVideoScreenState createState() => _UserVideoScreenState();
}

class _UserVideoScreenState extends State<UserVideoScreen> {
  int currentVideoIndex = 0;
  int currentPosition = 0;
  bool isPlaying = false;
  bool showControls = true;
  bool hasStartedPlaying =
      false; // Track if play started to trigger checkpoint timer
  Timer? _timer;
  List<Checkpoint> currentCheckpoints = [];
  Set<String> answeredCheckpoints = {};
  @override
  void initState() {
    super.initState();
    _loadCheckpoints();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _loadCheckpoints() {
    if (widget.videos.isEmpty) {
      currentCheckpoints = [];
      answeredCheckpoints.clear();
      return;
    }

    final checkpointsProvider = Provider.of<CheckpointsProvider>(context, listen: false);
    final video = widget.videos[currentVideoIndex];
    currentCheckpoints = checkpointsProvider.getCheckpointsByVideo(video.id);
    
    if (currentCheckpoints.isNotEmpty) {
      currentCheckpoints.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    }
    
    answeredCheckpoints.clear();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (isPlaying) {
        setState(() {
          currentPosition++;
        });
        _checkForCheckpoints();
      }
    });
  }

  void _togglePlayPause() {
    setState(() {
      isPlaying = !isPlaying;
      if (isPlaying && !hasStartedPlaying) {
        hasStartedPlaying = true;
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted &&
              isPlaying &&
              currentCheckpoints.isNotEmpty &&
              !answeredCheckpoints.contains(currentCheckpoints.first.id)) {
            _pauseVideo();
            _openCheckpointPage(currentCheckpoints.first);
          }
        });
      }
    });
  }

  void _seekTo(int position) {
    final video = widget.videos[currentVideoIndex];
    setState(() {
      currentPosition = position.clamp(0, video.duration);
    });
  }

  void _checkForCheckpoints() {
    for (final checkpoint in currentCheckpoints) {
      if (checkpoint.timestamp == currentPosition &&
          !answeredCheckpoints.contains(checkpoint.id)) {
        _pauseVideo();
        _openCheckpointPage(checkpoint);
        break;
      }
    }
  }

  void _pauseVideo() => setState(() => isPlaying = false);
  void _resumeVideo() => setState(() => isPlaying = true);
  void _openCheckpointPage(Checkpoint checkpoint) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckpointPage(
          checkpoint: checkpoint,
          onAnswerSelected: (selectedAnswer) {
         answeredCheckpoints.add(checkpoint.id.toString());
          bool isCorrect = selectedAnswer == checkpoint.correctAnswer;

            final video = widget.videos[currentVideoIndex];
            final authProvider = Provider.of<AuthProvider>(context, listen: false);
            final userId = int.tryParse(authProvider.currentUser?.id ?? '0') ?? 0;
            
            final progress = UserProgress(
              id: 0, 
              userId: userId,
              courseId: widget.course.id,
              watchedMinutes: (currentPosition / 60).floor(),
              progressPercentage: (answeredCheckpoints.length / currentCheckpoints.length) * 100,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            );
            
            Provider.of<UserProgressProvider>(context, listen: false)
                .addOrUpdateProgress(progress);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(isCorrect ? 'Correct!' : 'Incorrect!'),
                duration: const Duration(seconds: 2),
              ),
            );
            _resumeVideo();
          },
        ),
      ),
    );
  }

  void _nextVideo() {
    if (currentVideoIndex < widget.videos.length - 1) {
      setState(() {
        currentVideoIndex++;
        currentPosition = 0;
        hasStartedPlaying = false; // reset play start flag for new video
      });
      _loadCheckpoints();
    }
  }

  void _previousVideo() {
    if (currentVideoIndex > 0) {
      setState(() {
        currentVideoIndex--;
        currentPosition = 0;
        hasStartedPlaying = false; // reset play start flag for new video
      });
      _loadCheckpoints();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Safety check for empty videos list
    if (widget.videos.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.course.title)),
        body: const Center(
          child: Text('No videos available for this course'),
        ),
      );
    }

    final video = widget.videos[currentVideoIndex];
    final progressProvider = Provider.of<UserProgressProvider>(context);

    final courseProgress = progressProvider.getCourseProgress(
        widget.course.id, widget.videos);

    // Calculate video progress with null safety
    final videoProgress = currentCheckpoints.isNotEmpty
        ? (answeredCheckpoints.length / currentCheckpoints.length).clamp(0.0, 1.0)
        : (video.duration > 0 ? (currentPosition / video.duration).clamp(0.0, 1.0) : 0.0);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text(widget.course.title)),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: GestureDetector(
              onTap: () => setState(() => showControls = !showControls),
              child: Stack(
                children: [
                  Container(
                    color: Colors.black,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.video_library,
                              size: 80, color: Colors.white54),
                          const SizedBox(height: 16),
                          Text(video.title,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 20)),
                          const SizedBox(height: 10),
                          Text("Time: ${_formatTime(currentPosition)}",
                              style: const TextStyle(color: Colors.white70)),
                        ],
                      ),
                    ),
                  ),
                  if (showControls)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          LinearProgressIndicator(
                            value: videoProgress.clamp(0, 1),
                            backgroundColor: Colors.grey.shade800,
                            valueColor:
                                const AlwaysStoppedAnimation(Colors.blue),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                  icon: const Icon(Icons.skip_previous,
                                      color: Colors.white),
                                  onPressed: _previousVideo),
                              IconButton(
                                icon: Icon(
                                    isPlaying ? Icons.pause : Icons.play_arrow,
                                    size: 30,
                                    color: Colors.white),
                                onPressed: _togglePlayPause,
                              ),
                              IconButton(
                                  icon: const Icon(Icons.skip_next,
                                      color: Colors.white),
                                  onPressed: _nextVideo),
                            ],
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            color: Colors.grey.shade900,
            padding: const EdgeInsets.all(16),
            child: Text(
              video.title.isNotEmpty
                ? video.title
                : 'No title available',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final sec = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$sec';
  }
}

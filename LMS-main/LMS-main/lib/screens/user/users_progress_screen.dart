import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_progress_provider.dart';
import '../../providers/video_provider.dart';
import '../../models/course.dart';

class UserProgressScreen extends StatelessWidget {
  final List<Course> courses;

  const UserProgressScreen({super.key, required this.courses});

  @override
  Widget build(BuildContext context) {
    final videoProvider = Provider.of<VideoProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Progress"),
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
      ),
      body: Consumer<UserProgressProvider>(
        builder: (context, progressProvider, child) {
          if (courses.isEmpty) {
            return Center(
              child: Text(
                "No courses enrolled yet.",
                style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final course = courses[index];

              // Get videos for this course
              final courseVideos = videoProvider.getVideosByCourse(course.id);

              // Get user progress for this course
              final progress = progressProvider.getCourseProgress(
                course.id.toString().length,
                courseVideos,
              );

              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Stack(
                        children: [
                          Container(
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          LayoutBuilder(builder: (context, constraints) {
                            return Container(
                              height: 20,
                              width: constraints.maxWidth * (progress / 100),
                              decoration: BoxDecoration(
                                color: Colors.green.shade600,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            );
                          }),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${progress.toStringAsFixed(0)}% completed",
                            style: const TextStyle(fontSize: 14),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey.shade700,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

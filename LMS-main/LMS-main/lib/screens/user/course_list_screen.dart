import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/course_provider.dart';
import '../../providers/video_provider.dart';
import '../../models/category.dart';
import '../../widgets/course_card.dart';
import 'package:course_management_system/screens/user/video_player_screen.dart';

class CourseListScreen extends StatelessWidget {
  final Category category;
  const CourseListScreen({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.blue.shade100],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer2<CourseProvider, VideoProvider>(
            builder: (context, courseProvider, videoProvider, child) {
              if (courseProvider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (courseProvider.courses.isEmpty) {
                // Fetch courses if not already loaded
                Future.microtask(() => courseProvider.fetchCourses());
                return const Center(child: CircularProgressIndicator());
              }

              // ✅ Filter courses by category
              final courses = courseProvider.courses.where((c) {
                try {
                  return (c as dynamic).categoryId == category.id;
                } catch (_) {
                  return false;
                }
              }).toList();

              if (courses.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.book_outlined, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(
                        'No courses available in this category',
                        style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Available Courses:',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: courses.length,
                      itemBuilder: (context, index) {
                        final course = courses[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: CourseCard(
                            course: course,
                            categoryName: category.name,
                            onTap: () {
                              final videos = videoProvider.getVideosByCourse(course.id);
                              if (videos.isNotEmpty) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UserVideoScreen(
                                      course: course,
                                      videos: videos,
                                    ),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('No videos available for this course'),
                                  ),
                                );
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

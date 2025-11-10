import 'package:flutter/material.dart';
import 'package:course_management_system/models/course.dart';

class UserProfileScreen extends StatelessWidget {
  final String userEmail;
  final List<Course> userCourses;

  const UserProfileScreen({
    Key? key,
    required this.userEmail,
    required this.userCourses,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          children: [
            // Centered avatar
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.blueGrey.shade100,
                child: CircleAvatar(
                  radius: 56,
                  backgroundImage: AssetImage('lib/images/avatar.jpg'), // Use actual user avatar or placeholder
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              userEmail,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 24),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'My Courses',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    decoration: TextDecoration.underline),
              ),
            ),
            const SizedBox(height: 12),
            // Course list
            Expanded(
              child: userCourses.isNotEmpty
                  ? ListView.builder(
                      itemCount: userCourses.length,
                      itemBuilder: (context, index) {
                        final course = userCourses[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            title: Text(course.title),
                            subtitle: Text(course.instructor),
                            leading: const Icon(Icons.book, color: Colors.blue),
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text('No courses found',
                          style: TextStyle(fontSize: 16)),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

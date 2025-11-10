import 'package:course_management_system/screens/admin/enrollment_screen.dart';
import 'package:course_management_system/screens/user/course_list_screen.dart';
import 'package:course_management_system/screens/user/users_progress_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/course.dart';
import '../../providers/course_provider.dart';
import '../../providers/video_provider.dart';
import '../../providers/user_progress_provider.dart';
import 'category_selection_screen.dart';
import 'video_player_screen.dart';
import '../auth/login_screen.dart';
import 'user_profile screen.dart';

class UserDashboard extends StatelessWidget {
  final String username;

  const UserDashboard({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    final courseProvider = Provider.of<CourseProvider>(context);
    final videoProvider = Provider.of<VideoProvider>(context);
    final progressProvider = Provider.of<UserProgressProvider>(context);
    final ImageProvider userAvatar = const AssetImage('lib/images/avatar.jpg');

    // ✅ Placeholder course with correct type values
    final Course fallbackCourse = Course(
      id: 0,
      categoryId: 0,
      name: 'No Course',
      description: '',
      duration: '',
      level: CourseLevel.beginner,
      price: 0.0,
    );

    final List<Map<String, dynamic>> menuItems = [
      {
        'icon': Icons.category,
        'title': 'Categories',
        'screen': CategorySelectionScreen(),
        'color': Colors.deepOrangeAccent,
      },
      {
        'icon': Icons.book,
        'title': 'Courses',
        'screen': CategorySelectionScreen(),
        'color': Colors.teal,
      },
      {
        'icon': Icons.video_library,
        'title': 'Videos',
        'screen': UserVideoScreen(
          course: courseProvider.courses.isNotEmpty
              ? courseProvider.courses.first
              : fallbackCourse,
          videos: videoProvider.videos,
        ),
        'color': Colors.indigo,
      },
      {
        'icon': Icons.bar_chart,
        'title': 'Progress',
        'screen': UserProgressScreen(courses: courseProvider.courses),
        'color': Colors.deepPurple,
      },
      {
        'icon': Icons.lock,
        'title': 'Enrollment',
        'screen': CourseEnrollmentScreen(userId: int.tryParse(username) ?? 0),
        'color': Colors.orange,
      },
      {
        'icon': Icons.logout,
        'title': 'Logout',
        'screen': const LoginPage(),
        'color': Colors.redAccent,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 280,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 5, 224, 244),
                    Color.fromARGB(255, 146, 197, 217),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 46,
                      backgroundImage: userAvatar,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Welcome $username',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.4),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserProfileScreen(
                              userEmail: username,
                              userCourses: courseProvider.courses,
                            ),
                          ),
                        );
                      },
                      child: const Text('Profile'),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: menuItems.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                ),
                itemBuilder: (context, index) {
                  final item = menuItems[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => item['screen']));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: item['color'].withOpacity(0.15),
                            child: Icon(item['icon'],
                                color: item['color'], size: 28),
                          ),
                          const SizedBox(height: 12),
                          Text(item['title']),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

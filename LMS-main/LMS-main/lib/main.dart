import 'package:course_management_system/providers/user_progress_provider.dart';
import 'package:course_management_system/screens/auth/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/category_provider.dart';
import 'providers/course_provider.dart';
import 'providers/video_provider.dart';
import 'providers/checkpoints_provider.dart';
import 'screens/auth/login_screen.dart';
void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => CategoryProvider()),
        ChangeNotifierProvider(create: (context) => CourseProvider()),
        ChangeNotifierProvider(create: (context) => VideoProvider()),
        ChangeNotifierProvider(create: (context) => CheckpointsProvider()),
        ChangeNotifierProvider(create: (_context) => UserProgressProvider()),
      ],
      child: MaterialApp(
        title: 'Course Management System',
        theme: ThemeData(
          primarySwatch: Colors.orange,
                              ),
        home: SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
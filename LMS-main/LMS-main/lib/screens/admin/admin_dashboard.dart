
import 'package:course_management_system/screens/admin/category_master_screen.dart';
import 'package:course_management_system/screens/auth/registration_page.dart';
import 'package:flutter/material.dart';
import 'package:course_management_system/models/course.dart';
import 'package:course_management_system/screens/admin/category_master_screen.dart';
import 'package:course_management_system/screens/admin/course_master_screen.dart';
import 'package:course_management_system/screens/admin/course_videos_screen.dart';
import 'package:course_management_system/screens/admin/user_master_screen.dart';
import 'package:course_management_system/screens/auth/login_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}
class _AdminDashboardState extends State<AdminDashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int selectedIndex = -1;
  final List<Map<String, dynamic>> menuItems = [];
  @override
  void initState() {
    super.initState();
    menuItems.addAll([
      {
        'label':'Add Users',
        'icon':Icons.person_add,
        'widget':RegistrationPage(),
      },
      {
        'label': 'User Master',
        'icon': Icons.people,
        'widget': UserMasterScreen(),
      },
      {
        'label': 'Course Categories',
        'icon': Icons.category,
        'widget': CategoryMasterScreen(),
      },
      {
        'label': 'Courses',
        'icon': Icons.book,
        'widget': CourseMasterScreen(),
      },
      {
        'label':'course videos',
        'icon':Icons.video_library,
        'widget':CourseVideosScreen(),
      },
      {
        'label': 'Log out',
        'icon': Icons.logout,
        'widget': null,
      },
    ]);
  }

  void _handleLogout() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Logged out successfully")),
    );
    await Future.delayed(const Duration(milliseconds: 500));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
  @override
  Widget build(BuildContext context) {
    String appBarTitle = selectedIndex == -1
        ? "Welcome Admin"
        : menuItems[selectedIndex]['label'];
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(appBarTitle),
        centerTitle: true,
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer(); // open left drawer
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.blue),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage:
                          AssetImage("lib/images/withname png.png"),
                    ),
                    SizedBox(height: 12),
                    Text(
                      "Admin",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ...List.generate(menuItems.length, (index) {
              final item = menuItems[index];
              return ListTile(
                leading: Icon(item['icon'], color: Colors.blue),
                title: Text(item['label']),
                selected: selectedIndex == index,
                onTap: () {
                  Navigator.pop(context); // close drawer
                  if (item['label'] == 'Log out') {
                    _handleLogout();
                  } else {
                    setState(() {
                      selectedIndex = index;
                    });
                  }
                },
              );
            }),
          ],
        ),
      ),
      // Body shows welcome message initially
      body: selectedIndex == -1
          ? const Center(
              child: Text(
                "",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            )
          : menuItems[selectedIndex]['widget'] as Widget,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:course_management_system/screens/auth/login_screen.dart';
import 'package:video_player/video_player.dart';
void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const SplashScreen(),
   );
  }
}
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  void navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: VideoWidget(
        videopath: "lib/images/gannetz.mp4",
        onVideoEnd: navigateToLogin,
      ),
      extendBodyBehindAppBar: true,
    );
  }
}
class VideoWidget extends StatefulWidget {
  final String videopath;
  final VoidCallback onVideoEnd;
  const VideoWidget({Key? key, required this.videopath, required this.onVideoEnd}) : super(key: key);
  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}
class _VideoWidgetState extends State<VideoWidget> {
  late VideoPlayerController _videoController;
  late Future<void> _initializeVideoPlayerFuture;
  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset(widget.videopath);
    _initializeVideoPlayerFuture = _videoController.initialize().then((_) {
      setState(() {});
      _videoController.play();
    });
    _videoController.setLooping(false);
    _videoController.addListener(() {
      if (_videoController.value.position >= _videoController.value.duration) {
        widget.onVideoEnd();
      }
    });
  }
  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Stack(
            children: [
              Positioned.fill(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _videoController.value.size.width,
                    height: _videoController.value.size.height,
                    child: VideoPlayer(_videoController),
                  ),
                ),
              ),
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }
      },
    );
  }
}

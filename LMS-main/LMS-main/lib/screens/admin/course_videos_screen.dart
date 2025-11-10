import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/video_provider.dart';
import '../../models/course.dart';
import '../../models/video.dart';
import '../../widgets/custom_text_field.dart';

class CourseVideosScreen extends StatefulWidget {
  final Course course;

  const CourseVideosScreen({Key? key, required this.course}) : super(key: key);

  @override
  _CourseVideosScreenState createState() => _CourseVideosScreenState();
}

class _CourseVideosScreenState extends State<CourseVideosScreen> {
  final _titleController = TextEditingController();
  final _urlController = TextEditingController();
  final _durationController = TextEditingController();
  final _tagsController = TextEditingController();
  Video? _editingVideo;

  @override
  void dispose() {
    _titleController.dispose();
    _urlController.dispose();
    _durationController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  void _showVideoDialog([Video? video]) {
    _editingVideo = video;
    if (video != null) {
      _titleController.text = video.title;
      _urlController.text = video.youtubeUrl;
      _durationController.text = video.duration.toString();
      _tagsController.text = video.tags.join(', ');

    } else {
      _titleController.clear();
      _urlController.clear();
      _durationController.clear();
      _tagsController.clear();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_editingVideo == null ? 'Add Video' : 'Edit Video'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                controller: _titleController,
                labelText: 'Video Title',
                prefixIcon: Icons.title,
              ),
              SizedBox(height: 16),
              CustomTextField(
                controller: _urlController,
                labelText: 'Video URL',
                prefixIcon: Icons.link,
              ),
              SizedBox(height: 16),
              CustomTextField(
                controller: _durationController,
                labelText: 'Duration (seconds)',
                prefixIcon: Icons.timer,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              CustomTextField(
                controller: _tagsController,
                labelText: 'Tags (comma separated)',
                prefixIcon: Icons.tag,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _saveVideo,
            child: Text(_editingVideo == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }

  void _saveVideo() {
    if (_titleController.text.isEmpty || _urlController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in required fields')),
      );
      return;
    }

    final videoProvider = Provider.of<VideoProvider>(context, listen: false);
    final tags = _tagsController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final video = Video(
      id: _editingVideo?.id ?? 0,
      courseId: widget.course.id,
      title: _titleController.text,
      youtubeUrl: _urlController.text,
      duration: int.tryParse(_durationController.text) ?? 0,
       tags: tags,
    );

    if (_editingVideo == null) {
      videoProvider.addVideo(video);
    } else {
      videoProvider.updateVideo(video);
    }

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_editingVideo == null
            ? 'Video added successfully'
            : 'Video updated successfully'),
      ),
    );
  }

  void _deleteVideo(int videoId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Video'),
        content: Text(
            'Are you sure you want to delete this video? All associated checkpoints will also be deleted.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<VideoProvider>(context, listen: false)
                  .deleteVideo(videoId);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Video deleted successfully')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  String _formatDuration(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes}m ${remainingSeconds}s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.course.title} - Videos'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showVideoDialog(),
        backgroundColor: Colors.blue,
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: Consumer<VideoProvider>(
        builder: (context, videoProvider, child) {
          final videos = videoProvider.getVideosByCourse(widget.course.id);

          if (videos.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.video_library_outlined,
                      size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No videos found',
                      style: TextStyle(fontSize: 18, color: Colors.grey)),
                  SizedBox(height: 8),
                  Text('Add videos to get started',
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: videos.length,
            itemBuilder: (context, index) {
              final video = videos[index];
                final checkpointCount = videoProvider.getVideosByCourse(video.id)?.length ?? 0;

              return Card(
                elevation: 4,
                margin: EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  leading: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.play_circle_filled,
                        color: Colors.blue, size: 32),
                  ),
                  title: Text(
                    video.title,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4),
                      Text('Duration: ${_formatDuration(video.duration)}'),
                      Text('Checkpoints: $checkpointCount'),
                      if (video.tags.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Wrap(
                            spacing: 4,
                            children: video.tags.map<Widget>((tag) {
                             return Chip(
                              label: Text(tag, style: TextStyle(fontSize: 10)),
                              backgroundColor: Colors.blue.shade50,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              );
                               }).toList(),
                          ),
                        ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showVideoDialog(video),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteVideo(video.id),
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

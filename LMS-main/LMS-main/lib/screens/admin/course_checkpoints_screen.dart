import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/video_provider.dart';
import '../../providers/checkpoints_provider.dart';
import '../../models/video.dart';
import '../../models/course.dart';
import '../../models/checkpoint.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/empty_state_widget.dart';

class CourseCheckpointsScreen extends StatefulWidget {
  final Course course;

  const CourseCheckpointsScreen({Key? key, required this.course})
      : super(key: key);

  @override
  State<CourseCheckpointsScreen> createState() =>
      _CourseCheckpointsScreenState();
}

class _CourseCheckpointsScreenState extends State<CourseCheckpointsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final _timeController = TextEditingController();
  final List<TextEditingController> _choiceControllers =
      List.generate(4, (_) => TextEditingController());

  int? _selectedVideoId;
  int _correctAnswerIndex = 0;
  Checkpoint? _editingCheckpoint;
  bool _isLoading = false;

  @override
  void dispose() {
    _questionController.dispose();
    _timeController.dispose();
    for (var controller in _choiceControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _showCheckpointDialog([Checkpoint? checkpoint]) {
    _editingCheckpoint = checkpoint;
    if (checkpoint != null) {
      _questionController.text = checkpoint.question;
      _timeController.text = checkpoint.timestamp.toString();
      _selectedVideoId = checkpoint.videoId;
      _correctAnswerIndex = checkpoint.choices.indexOf(checkpoint.correctAnswer);
      for (int i = 0; i < checkpoint.choices.length && i < 4; i++) {
        _choiceControllers[i].text = checkpoint.choices[i];
      }
    } else {
      _questionController.clear();
      _timeController.clear();
      _selectedVideoId = null;
      _correctAnswerIndex = 0;
      for (var c in _choiceControllers) {
        c.clear();
      }
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              _editingCheckpoint == null ? Icons.add_circle : Icons.edit,
              color: Colors.green.shade600,
            ),
            SizedBox(width: 8),
            Text(_editingCheckpoint == null ? 'Add Checkpoint' : 'Edit Checkpoint'),
          ],
        ),
        content: StatefulBuilder(
          builder: (context, setState) => Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Consumer<VideoProvider>(
                    builder: (context, videoProvider, child) {
                      final videos = videoProvider.getVideosByCourse(widget.course.id);
                      if (videos.isEmpty) {
                        return Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.orange.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.warning, color: Colors.orange),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'No videos found. Add videos first before creating checkpoints.',
                                  style: TextStyle(color: Colors.orange.shade700),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return DropdownButtonFormField<int>(
                        value: _selectedVideoId,
                        decoration: InputDecoration(
                          labelText: 'Select Video *',
                          prefixIcon: Icon(Icons.video_library),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        validator: (value) => value == null ? 'Please select a video' : null,
                        items: videos.map((video) {
                          return DropdownMenuItem(
                            value: video.id,
                            child: Text('${video.title} (${_formatDuration(video.duration)})'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() => _selectedVideoId = value);
                        },
                      );
                    },
                  ),
                  SizedBox(height: 16),
                  CustomTextField(
                    controller: _timeController,
                    labelText: 'Time in seconds *',
                    prefixIcon: Icons.timer,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter time';
                      final time = int.tryParse(value);
                      if (time == null || time < 0) return 'Enter a valid positive number';
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  CustomTextField(
                    controller: _questionController,
                    labelText: 'Question *',
                    prefixIcon: Icons.quiz,
                    maxLines: 3,
                    validator: (value) =>
                        value == null || value.trim().isEmpty ? 'Enter a question' : null,
                  ),
                  SizedBox(height: 16),
                  Text('Answer Choices:', style: TextStyle(fontWeight: FontWeight.bold)),
                  ...List.generate(4, (index) {
                    return Row(
                      children: [
                        Radio<int>(
                          value: index,
                          groupValue: _correctAnswerIndex,
                          onChanged: (value) {
                            setState(() => _correctAnswerIndex = value!);
                          },
                          activeColor: Colors.green,
                        ),
                        Expanded(
                          child: CustomTextField(
                            controller: _choiceControllers[index],
                            labelText: 'Choice ${index + 1} *',
                            validator: (value) =>
                                value == null || value.trim().isEmpty ? 'Enter choice ${index + 1}' : null,
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          ElevatedButton(
            onPressed: _isLoading ? null : _saveCheckpoint,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade600),
            child: _isLoading
                ? SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                : Text(_editingCheckpoint == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveCheckpoint() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final provider = Provider.of<CheckpointsProvider>(context, listen: false);
      final choices = _choiceControllers.map((c) => c.text.trim()).toList();
      final checkpoint = Checkpoint(
        id: _editingCheckpoint?.id ?? 0,
        videoId: _selectedVideoId!,
        timestamp: int.parse(_timeController.text),
        question: _questionController.text.trim(),
        choices: choices,
        correctAnswer: choices[_correctAnswerIndex],
        required: true,
      );

      if (_editingCheckpoint == null) {
        await provider.addCheckpoint(checkpoint);
      } else {
        await provider.updateCheckpoint(checkpoint);
      }

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Checkpoint saved successfully'), backgroundColor: Colors.green),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes}m ${secs}s';
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes}:${secs.toString().padLeft(2, '0')}';
  }

  void _deleteCheckpoint(Checkpoint checkpoint) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Delete Checkpoint'),
        content: Text('Are you sure you want to delete this checkpoint?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Cancel')),
          ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Delete'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red)),
        ],
      ),
    );
    if (confirmed ?? false) {
      final provider = Provider.of<CheckpointsProvider>(context, listen: false);
      await provider.deleteCheckpoint(checkpoint.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Checkpoint deleted'), backgroundColor: Colors.orange),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkpoints - ${widget.course.title}'),
        backgroundColor: Colors.green.shade600,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCheckpointDialog(),
        icon: Icon(Icons.add),
        label: Text('Add Checkpoint'),
      ),
      body: Consumer2<VideoProvider, CheckpointsProvider>(
        builder: (context, videoProvider, checkpointProvider, child) {
          final videos = videoProvider.getVideosByCourse(widget.course.id);
          final allCheckpoints = videos
              .expand((video) => checkpointProvider.getCheckpointsByVideo(video.id))
              .toList();

          if (videos.isEmpty) {
            return EmptyStateWidget(
              icon: Icons.video_library_outlined,
              title: 'No Videos Available',
              subtitle: 'Add videos before creating checkpoints.',
              action: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back),
                label: Text('Go Back'),
              ),
            );
          }

          if (allCheckpoints.isEmpty) {
            return EmptyStateWidget(
              icon: Icons.quiz_outlined,
              title: 'No Checkpoints',
              subtitle: 'Create interactive checkpoints to engage students.',
              action: ElevatedButton.icon(
                onPressed: () => _showCheckpointDialog(),
                icon: Icon(Icons.add),
                label: Text('Add First Checkpoint'),
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: allCheckpoints.length,
            itemBuilder: (_, index) {
              final checkpoint = allCheckpoints[index];
              final video = videos.firstWhere(
                (v) => v.id == checkpoint.videoId,
                orElse: () => Video(
                  id: 0,
                  title: 'Unknown',
                  duration: 0,
                  courseId: widget.course.id,
                  youtubeUrl: '',
                ),
              );
              return Card(
                margin: EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  title: Text(checkpoint.question),
                  subtitle: Text('Video: ${video.title} at ${_formatTime(checkpoint.timestamp)}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: Icon(Icons.edit, color: Colors.blue), onPressed: () => _showCheckpointDialog(checkpoint)),
                      IconButton(icon: Icon(Icons.delete, color: Colors.red), onPressed: () => _deleteCheckpoint(checkpoint)),
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

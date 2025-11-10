import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/course.dart';
import '../../providers/course_provider.dart';
import '../../widgets/custom_text_field.dart';

class CourseMasterScreen extends StatefulWidget {
  const CourseMasterScreen({super.key});

  @override
  State<CourseMasterScreen> createState() => _CourseMasterScreenState();
}

class _CourseMasterScreenState extends State<CourseMasterScreen> {
  final _titleController = TextEditingController();
  final _instructorController = TextEditingController();
  final _durationController = TextEditingController();
  final _priceController = TextEditingController();
  CourseLevel _selectedLevel = CourseLevel.beginner;
  Course? _editingCourse;

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<CourseProvider>(context, listen: false).fetchCourses());
  }

  void _showCourseDialog([Course? course]) {
    if (course != null) {
      _editingCourse = course;
      _titleController.text = course.title;
      _instructorController.text = course.instructor;
      _durationController.text = course.duration;
      _priceController.text = course.price.toString();
      _selectedLevel = course.level;
    } else {
      _editingCourse = null;
      _titleController.clear();
      _instructorController.clear();
      _durationController.clear();
      _priceController.clear();
      _selectedLevel = CourseLevel.beginner;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(_editingCourse == null ? 'Add Course' : 'Edit Course'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              CustomTextField(controller: _titleController, labelText: 'Title'),
              const SizedBox(height: 10),
              CustomTextField(controller: _instructorController, labelText: 'Instructor'),
              const SizedBox(height: 10),
              DropdownButtonFormField<CourseLevel>(
                value: _selectedLevel,
                decoration: const InputDecoration(labelText: 'Level'),
                items: CourseLevel.values.map((level) {
                  return DropdownMenuItem(
                      value: level, child: Text(level.displayName));
                }).toList(),
                onChanged: (v) => setState(() => _selectedLevel = v!),
              ),
              const SizedBox(height: 10),
              CustomTextField(controller: _durationController, labelText: 'Duration'),
              const SizedBox(height: 10),
              CustomTextField(
                controller: _priceController,
                labelText: 'Price',
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: _saveCourse,
            child: Text(_editingCourse == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveCourse() async {
    final title = _titleController.text.trim();
    final instructor = _instructorController.text.trim();
    final duration = _durationController.text.trim();
    final price = double.tryParse(_priceController.text.trim()) ?? 0.0;

    if (title.isEmpty || instructor.isEmpty || duration.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    final newCourse = Course(
      id: _editingCourse?.id ?? 0,
      title: title,
      instructor: instructor,
      level: _selectedLevel,
      price: price,
      duration: duration,
    );

    final provider = Provider.of<CourseProvider>(context, listen: false);

    try {
      if (_editingCourse == null) {
        await provider.addCourse(newCourse);
      } else {
        await provider.updateCourse(newCourse.id, newCourse);
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving course: $e')));
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _instructorController.dispose();
    _durationController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Course Master')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCourseDialog(),
        child: const Icon(Icons.add),
      ),
      body: Consumer<CourseProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.courses.isEmpty) {
            return const Center(child: Text('No courses found.'));
          }

          return ListView.builder(
            itemCount: provider.courses.length,
            itemBuilder: (context, index) {
              final course = provider.courses[index];
              return ListTile(
                title: Text(course.title),
                subtitle: Text(
                    'Instructor: ${course.instructor} | Level: ${course.level.displayName}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showCourseDialog(course)),
                    IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () =>
                            Provider.of<CourseProvider>(context, listen: false)
                                .deleteCourse(course.id)),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

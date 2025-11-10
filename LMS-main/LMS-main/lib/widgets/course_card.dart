import 'package:flutter/material.dart';
import '../models/course.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final VoidCallback onTap;
  final String? categoryName;

  const CourseCard({
    Key? key,
    required this.course,
    required this.onTap,
    this.categoryName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue.shade50, Colors.blue.shade100],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.play_circle_filled,
                        color: Colors.blue.shade700),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (categoryName != null)
                          Text(
                            categoryName!,
                            style: TextStyle(
                              color: Colors.blue.shade600,
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                course.description,
                style: TextStyle(color: Colors.grey.shade600),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Chip(
                    label: Text(course.duration),
                    backgroundColor: Colors.green.shade100,
                    labelStyle:
                        TextStyle(color: Colors.green.shade700, fontSize: 12),
                  ),
                  Chip(
                    label: Text(course.level.displayName),
                    backgroundColor: Colors.orange.shade100,
                    labelStyle:
                        TextStyle(color: Colors.orange.shade700, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

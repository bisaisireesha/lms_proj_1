import 'dart:convert';

enum CourseLevel { beginner, intermediate, advanced, expert }

extension CourseLevelExtension on CourseLevel {
  String get displayName {
    switch (this) {
      case CourseLevel.beginner:
        return 'beginner';
      case CourseLevel.intermediate:
        return 'intermediate';
      case CourseLevel.advanced:
        return 'advanced';
      case CourseLevel.expert:
        return 'expert';
    }
  }

  static CourseLevel fromString(String level) {
    switch (level.toLowerCase()) {
      case 'beginner':
        return CourseLevel.beginner;
      case 'intermediate':
        return CourseLevel.intermediate;
      case 'advanced':
        return CourseLevel.advanced;
      case 'expert':
        return CourseLevel.expert;
      default:
        return CourseLevel.beginner;
    }
  }
}
class Course {
  final int id;
  final String title;
  final String instructor;
  final CourseLevel level;
  final double price;
  final String duration;

  Course({
    required this.id,
    required this.title,
    required this.instructor,
    required this.level,
    required this.price,
    required this.duration,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      instructor: json['instructor'] ?? '',
      level: CourseLevelExtension.fromString(json['level'] ?? 'beginner'),
      price: (json['price'] ?? 0).toDouble(),
      duration: json['duration']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'instructor': instructor,
      'level': level.displayName,
      'price': price,
      'duration': duration,
    };
  }

  static List<Course> fromList(List data) {
    return data.map((e) => Course.fromJson(e)).toList();
  }
}

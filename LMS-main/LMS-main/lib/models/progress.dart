class UserProgress {
  final int id;
  final int userId;
  final int courseId;
  final int watchedMinutes;
  final double progressPercentage;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProgress({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.watchedMinutes,
    required this.progressPercentage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProgress.fromJson(Map<String, dynamic> json) => UserProgress(
        id: json['id'],
        userId: json['user_id'],
        courseId: json['course_id'],
        watchedMinutes: json['watched_minutes'],
        progressPercentage: (json['progress_percentage'] as num).toDouble(),
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'course_id': courseId,
        'watched_minutes': watchedMinutes,
        'progress_percentage': progressPercentage,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };
}

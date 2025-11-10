class Video {
  final int id;
  final int courseId;
  final String title;
  final String youtubeUrl;
  final int duration;
  final List<String> tags;
  
  Video({
    required this.id,
    required this.courseId,
    required this.title,
    required this.youtubeUrl,
    required this.duration,
    this.tags = const [],
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'],
      courseId: json['course_id'],
      title: json['title'],
      youtubeUrl: json['youtube_url'],
      duration: json['duration'],
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course_id': courseId,
      'title': title,
      'youtube_url': youtubeUrl,
      'duration': duration,
      'tags': tags,
    };
  }
}

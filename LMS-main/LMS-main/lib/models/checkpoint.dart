// models/checkpoint.dart
class Checkpoint {
  final int id;
  final int videoId;
  final int timestamp; // in seconds
  final String question;
  final List<String> choices;
  final String correctAnswer;
  final bool required;

  Checkpoint({
    required this.id,
    required this.videoId,
    required this.timestamp,
    required this.question,
    required this.choices,
    required this.correctAnswer,
    required this.required,
  });

  factory Checkpoint.fromJson(Map<String, dynamic> json) {
    // Convert choices from comma-separated string to List
    List<String> choicesList = [];
    if (json['choices'] != null && json['choices'] is String) {
      choicesList = (json['choices'] as String).split(',').map((e) => e.trim()).toList();
    }

    return Checkpoint(
      id: json['id'],
      videoId: json['video_id'],
      timestamp: json['timestamp'],
      question: json['question'],
      choices: choicesList,
      correctAnswer: json['correct_answer'],
      required: json['required'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'video_id': videoId,
      'timestamp': timestamp,
      'question': question,
      'choices': choices.join(','), 
      'correct_answer': correctAnswer,
      'required': required,
    };
  }
}

class Question {
  final String id;
  final String text;
  final List<String> options;
  final int correctOptionIndex;
  final String explanation;
  final String difficulty;

  Question({
    required this.id,
    required this.text,
    required this.options,
    required this.correctOptionIndex,
    required this.explanation,
    required this.difficulty,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'].toString(),
      text: json['question'] as String,
      options: List<String>.from(json['options']),
      correctOptionIndex: json['correctIndex'] as int,
      explanation: json['explanation'] as String,
      difficulty: json['difficulty'] as String? ?? 'Medium',
    );
  }
}

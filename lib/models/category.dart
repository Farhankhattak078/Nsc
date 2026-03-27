import 'package:flutter/widgets.dart';

class QuizCategory {
  final String id;
  final String title;
  final IconData icon;
  final double progress; // 0.0 to 1.0
  final int totalQuizzes;
  final int attemptedQuizzes;
  final String jsonFileName;

  QuizCategory({
    required this.id,
    required this.title,
    required this.icon,
    required this.progress,
    required this.totalQuizzes,
    required this.attemptedQuizzes,
    required this.jsonFileName,
  });
}

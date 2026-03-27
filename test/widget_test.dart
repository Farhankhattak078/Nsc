import 'package:flutter_test/flutter_test.dart';
import 'package:nsct/models/category.dart';
import 'package:nsct/models/question.dart';
import 'package:lucide_icons/lucide_icons.dart';

void main() {
  group('Model Tests', () {
    test('Question model deserializes correctly from JSON', () {
      final jsonMap = {
        "id": "1",
        "question": "What is the capital of France?",
        "options": ["London", "Berlin", "Paris", "Madrid"],
        "correctIndex": 2,
        "explanation": "Paris is the capital of France.",
        "difficulty": "Easy"
      };

      final question = Question.fromJson(jsonMap);

      expect(question.text, 'What is the capital of France?');
      expect(question.options.length, 4);
      expect(question.options[2], 'Paris');
      expect(question.correctOptionIndex, 2);
      expect(question.explanation, 'Paris is the capital of France.');
      expect(question.difficulty, 'Easy');
    });

    test('QuizCategory creation is valid', () {
      final category = QuizCategory(
        id: 'test_category',
        title: 'Test Category',
        icon: LucideIcons.testTube,
        progress: 0.5,
        totalQuizzes: 10,
        attemptedQuizzes: 5,
        jsonFileName: 'test.json',
      );

      expect(category.id, 'test_category');
      expect(category.title, 'Test Category');
      expect(category.jsonFileName, 'test.json');
    });
  });
}

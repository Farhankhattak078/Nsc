import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _keyTotalCorrect = 'total_correct';
  static const String _keyTotalQuestions = 'total_questions';
  static const String _keyStreak = 'current_streak';
  static const String _keyLastQuizDate = 'last_quiz_date';
  static const String _keyOnboardingSeen = 'onboarding_seen';
  
  // Singleton pattern
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Getters
  bool get hasSeenOnboarding => _prefs.getBool(_keyOnboardingSeen) ?? false;

  Future<void> setOnboardingSeen() async {
    await _prefs.setBool(_keyOnboardingSeen, true);
  }

  int get totalCorrect => _prefs.getInt(_keyTotalCorrect) ?? 0;
  int get totalQuestions => _prefs.getInt(_keyTotalQuestions) ?? 0;
  
  double get accuracy {
    if (totalQuestions == 0) return 0.0;
    return (totalCorrect / totalQuestions);
  }

  int get streak => _prefs.getInt(_keyStreak) ?? 0;

  int getCategoryAttemptedQuizzes(String categoryId) {
    return _prefs.getInt('category_${categoryId}_attempts') ?? 0;
  }

  int get totalAttemptedQuizzes {
    return _prefs.getInt('total_attempted_quizzes') ?? 0;
  }

  Future<void> saveQuizResult(String categoryId, int score, int totalQ) async {
    await _prefs.setInt(_keyTotalCorrect, totalCorrect + score);
    await _prefs.setInt(_keyTotalQuestions, totalQuestions + totalQ);
    await _prefs.setInt('total_attempted_quizzes', totalAttemptedQuizzes + 1);

    int catAttempts = getCategoryAttemptedQuizzes(categoryId);
    await _prefs.setInt('category_${categoryId}_attempts', catAttempts + 1);

    await _updateStreak();
  }

  Future<void> _updateStreak() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    final lastQuizMillis = _prefs.getInt(_keyLastQuizDate);
    
    if (lastQuizMillis == null) {
      await _prefs.setInt(_keyStreak, 1);
      await _prefs.setInt(_keyLastQuizDate, today.millisecondsSinceEpoch);
      return;
    }

    final lastQuizDate = DateTime.fromMillisecondsSinceEpoch(lastQuizMillis);
    final difference = today.difference(lastQuizDate).inDays;

    if (difference == 0) {
      // Same day, do nothing to streak
      return;
    } else if (difference == 1) {
      // Continuation
      await _prefs.setInt(_keyStreak, streak + 1);
      await _prefs.setInt(_keyLastQuizDate, today.millisecondsSinceEpoch);
    } else {
      // Streak broken
      await _prefs.setInt(_keyStreak, 1);
      await _prefs.setInt(_keyLastQuizDate, today.millisecondsSinceEpoch);
    }
  }
}

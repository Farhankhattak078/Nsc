import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/category.dart';
import '../screens/quiz_screen.dart';
import '../services/storage_service.dart';

// Per-category accent color map
const Map<String, Color> _categoryColors = {
  '1': Color(0xFF4F46E5), // Computer Networks - Indigo
  '2': Color(0xFF0EA5E9), // Programming - Blue
  '3': Color(0xFF10B981), // Data Structures - Green
  '4': Color(0xFFF59E0B), // Operating Systems - Amber
  '5': Color(0xFFEC4899), // Software Engineering - Pink
  '6': Color(0xFF8B5CF6), // Web Dev - Purple
  '7': Color(0xFF06B6D4), // AI - Cyan
  '8': Color(0xFFEF4444), // Cyber Security - Red
  '9': Color(0xFF14B8A6), // Databases - Teal
  '10': Color(0xFFF97316), // Problem Solving - Orange
};

class CategoryCard extends StatelessWidget {
  final QuizCategory category;

  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accent = _categoryColors[category.id] ?? theme.primaryColor;

    final attempted = StorageService().getCategoryAttemptedQuizzes(category.id);
    double progress = category.totalQuizzes > 0 ? (attempted / category.totalQuizzes) : 0.0;
    if (progress > 1.0) progress = 1.0;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuizScreen(category: category),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(18),
            // Uniform border — no non-uniform border with borderRadius
            border: Border.all(
              color: isDark ? Colors.white.withValues(alpha: 0.07) : Colors.black.withValues(alpha: 0.06),
            ),
            boxShadow: [
              BoxShadow(
                color: accent.withValues(alpha: 0.1),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Stack(
              children: [
                // Colored top accent strip
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 4,
                    color: accent,
                  ),
                ),
                // Card content
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 18, 14, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(category.icon, color: accent, size: 24),
                      ),
                      const Spacer(),
                      // Title
                      Text(
                        category.title,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF111827),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      // Progress row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Progress',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            '${(progress * 100).toInt()}%',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: accent,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // Progress bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: isDark ? Colors.white12 : Colors.grey.shade100,
                          valueColor: AlwaysStoppedAnimation<Color>(accent),
                          minHeight: 5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

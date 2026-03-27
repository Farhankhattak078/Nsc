import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nsct/main.dart' show AppThemeController;
import '../models/category.dart';
import '../widgets/category_card.dart';
import '../services/auth_service.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<QuizCategory> categories = [
    QuizCategory(id: '1', title: 'Computer Networks', icon: LucideIcons.globe, progress: 0.8, totalQuizzes: 10, attemptedQuizzes: 8, jsonFileName: 'networking.json'),
    QuizCategory(id: '2', title: 'Programming', icon: LucideIcons.code, progress: 0.45, totalQuizzes: 20, attemptedQuizzes: 9, jsonFileName: 'programming.json'),
    QuizCategory(id: '3', title: 'Data Structures', icon: LucideIcons.network, progress: 0.2, totalQuizzes: 15, attemptedQuizzes: 3, jsonFileName: 'DSA.json'),
    QuizCategory(id: '4', title: 'Operating Systems', icon: LucideIcons.cpu, progress: 0.1, totalQuizzes: 10, attemptedQuizzes: 1, jsonFileName: 'OS.json'),
    QuizCategory(id: '5', title: 'Software Engineering', icon: LucideIcons.layers, progress: 0.0, totalQuizzes: 10, attemptedQuizzes: 0, jsonFileName: 'software_engineering.json'),
    QuizCategory(id: '6', title: 'Web Development', icon: LucideIcons.layout, progress: 0.0, totalQuizzes: 15, attemptedQuizzes: 0, jsonFileName: 'web_development.json'),
    QuizCategory(id: '7', title: 'AI & Data Analytics', icon: LucideIcons.brain, progress: 0.0, totalQuizzes: 12, attemptedQuizzes: 0, jsonFileName: 'AI.json'),
    QuizCategory(id: '8', title: 'Cyber Security', icon: LucideIcons.shield, progress: 0.0, totalQuizzes: 10, attemptedQuizzes: 0, jsonFileName: 'cybersecurity.json'),
    QuizCategory(id: '9', title: 'Databases', icon: LucideIcons.database, progress: 0.0, totalQuizzes: 12, attemptedQuizzes: 0, jsonFileName: 'database.json'),
    QuizCategory(id: '10', title: 'Problem Solving', icon: LucideIcons.puzzle, progress: 0.0, totalQuizzes: 10, attemptedQuizzes: 0, jsonFileName: 'problem_solving.json'),
  ];

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (_currentIndex == 1) {
      content = ProfileScreen(
        onBackPressed: () => setState(() => _currentIndex = 0),
      );
    } else {
      final User? user = AuthService().currentUser;
      final theme = Theme.of(context);
      final isDark = theme.brightness == Brightness.dark;
      final firstName = user?.displayName?.split(' ').first ?? 'there';

      content = Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello, $firstName 👋',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Let\'s sharpen your skills',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Theme toggle button
                  GestureDetector(
                    onTap: () => AppThemeController.of(context).toggleTheme(),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isDark ? LucideIcons.sun : LucideIcons.moon,
                        size: 20,
                        color: isDark ? const Color(0xFFFBBF24) : const Color(0xFF4F46E5),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Avatar — tapping goes to Profile tab
                  GestureDetector(
                    onTap: () => setState(() => _currentIndex = 1),
                    child: Container(
                      padding: const EdgeInsets.all(2.5),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Color(0xFF4338CA), Color(0xFF6366F1)],
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 22,
                        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                        backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
                        child: user?.photoURL == null
                            ? Text(
                                (user?.displayName?.isNotEmpty == true)
                                    ? user!.displayName![0].toUpperCase()
                                    : '?',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF4F46E5),
                                ),
                              )
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // ── Section title ────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'All Categories',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${categories.length} topics',
                    style: GoogleFonts.inter(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),
            // ── Grid ─────────────────────────────────────────
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                physics: const BouncingScrollPhysics(),
                itemCount: categories.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 220,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                ),
                itemBuilder: (context, index) => CategoryCard(category: categories[index]),
              ),
            ),
          ],
        ),
      ),
      // ── Bottom Nav ──────────────────────────────────────
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          selectedItemColor: const Color(0xFF4F46E5),
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 12),
          unselectedLabelStyle: GoogleFonts.inter(fontSize: 12),
          items: const [
            BottomNavigationBarItem(icon: Icon(LucideIcons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(LucideIcons.user), label: 'Profile'),
          ],
        ),
      ),
    );
    }

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        if (_currentIndex != 0) {
          setState(() => _currentIndex = 0);
          return false;
        }
        return true;
      },
      child: content,
    );
  }
}

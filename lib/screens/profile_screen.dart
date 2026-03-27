import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/storage_service.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  final VoidCallback? onBackPressed;

  const ProfileScreen({super.key, this.onBackPressed});

  @override
  Widget build(BuildContext context) {
    final User? user = AuthService().currentUser;
    final storage = StorageService();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Gradient Header + Stats Card (stacked) ──────
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Gradient background
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppTheme.primaryGradientStart,
                        AppTheme.primaryGradientEnd,
                      ],
                    ),
                  ),
                  // Extra bottom padding to make room for the overlapping card
                  padding: const EdgeInsets.only(bottom: 60),
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title row
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Profile',
                                  style: GoogleFonts.poppins(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: IconButton(
                                  icon: const Icon(LucideIcons.arrowLeft, color: Colors.white, size: 20),
                                  onPressed: () {
                                    if (onBackPressed != null) {
                                      onBackPressed!();
                                    } else {
                                      Navigator.of(context).pop();
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // User row
                          Row(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white.withValues(alpha: 0.3),
                                    ),
                                    child: CircleAvatar(
                                      radius: 38,
                                      backgroundColor: Colors.white,
                                      backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
                                      child: user?.photoURL == null
                                          ? Text(
                                              (user?.displayName?.isNotEmpty == true)
                                                  ? user!.displayName![0].toUpperCase()
                                                  : '?',
                                              style: GoogleFonts.poppins(
                                                fontSize: 26,
                                                fontWeight: FontWeight.bold,
                                                color: AppTheme.primaryColor,
                                              ),
                                            )
                                          : null,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 2,
                                    right: 2,
                                    child: Container(
                                      width: 16,
                                      height: 16,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF10B981),
                                        shape: BoxShape.circle,
                                        border: Border.fromBorderSide(
                                          BorderSide(color: Colors.white, width: 2),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user?.displayName ?? 'Anonymous User',
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      user?.email ?? 'No email saved',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: Colors.white.withValues(alpha: 0.75),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(LucideIcons.star, size: 11, color: Color(0xFFFBBF24)),
                                          const SizedBox(width: 4),
                                          Text(
                                            'Active Learner',
                                            style: GoogleFonts.inter(
                                              fontSize: 11,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Floating stats card — positioned to overlap the gradient bottom
                Positioned(
                  bottom: -50,
                  left: 20,
                  right: 20,
                  child: _buildStatsCard(context, storage, isDark),
                ),
              ],
            ),
            // Space for the overlapping stats card
            const SizedBox(height: 66),
            // ── Performance by Category ───────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Text(
                'Performance by Category',
                style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildCategoryProgress(context, 'Computer Networks', storage.getCategoryAttemptedQuizzes('1') / 10.0, const Color(0xFF4F46E5), LucideIcons.globe, isDark),
                  _buildCategoryProgress(context, 'Programming', storage.getCategoryAttemptedQuizzes('2') / 20.0, const Color(0xFF0EA5E9), LucideIcons.code, isDark),
                  _buildCategoryProgress(context, 'Data Structures', storage.getCategoryAttemptedQuizzes('3') / 15.0, const Color(0xFF10B981), LucideIcons.network, isDark),
                  _buildCategoryProgress(context, 'Operating Systems', storage.getCategoryAttemptedQuizzes('4') / 10.0, const Color(0xFFF59E0B), LucideIcons.cpu, isDark),
                  _buildCategoryProgress(context, 'Software Engineering', storage.getCategoryAttemptedQuizzes('5') / 10.0, const Color(0xFFEC4899), LucideIcons.layers, isDark),
                  _buildCategoryProgress(context, 'Web Development', storage.getCategoryAttemptedQuizzes('6') / 15.0, const Color(0xFF8B5CF6), LucideIcons.layout, isDark),
                  _buildCategoryProgress(context, 'AI & Data Analytics', storage.getCategoryAttemptedQuizzes('7') / 12.0, const Color(0xFF06B6D4), LucideIcons.brain, isDark),
                  _buildCategoryProgress(context, 'Cyber Security', storage.getCategoryAttemptedQuizzes('8') / 10.0, const Color(0xFFEF4444), LucideIcons.shield, isDark),
                  _buildCategoryProgress(context, 'Databases', storage.getCategoryAttemptedQuizzes('9') / 12.0, const Color(0xFF14B8A6), LucideIcons.database, isDark),
                  _buildCategoryProgress(context, 'Problem Solving', storage.getCategoryAttemptedQuizzes('10') / 10.0, const Color(0xFFF97316), LucideIcons.puzzle, isDark),
                ],
              ),
            ),
            // ── Logout ────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(14),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () async => await AuthService().signOut(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red.withValues(alpha: 0.4)),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(LucideIcons.logOut, color: Colors.red, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Log Out',
                          style: GoogleFonts.inter(
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard(BuildContext context, StorageService storage, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildStatItem('${storage.totalAttemptedQuizzes}', 'Quizzes', LucideIcons.bookOpen, const Color(0xFF4F46E5)),
          _buildDivider(isDark),
          _buildStatItem('${(storage.accuracy * 100).toInt()}%', 'Accuracy', LucideIcons.target, const Color(0xFF10B981)),
          _buildDivider(isDark),
          _buildStatItem('${storage.streak}', 'Day Streak', LucideIcons.flame, const Color(0xFFF59E0B)),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon, Color color) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 8),
          Text(value, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(label, style: GoogleFonts.inter(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Container(
      height: 50,
      width: 1,
      color: isDark ? Colors.white12 : Colors.grey.shade200,
    );
  }

  Widget _buildCategoryProgress(BuildContext context, String title, double rawProgress, Color color, IconData icon, bool isDark) {
    final progress = rawProgress > 1.0 ? 1.0 : (rawProgress.isNaN ? 0.0 : rawProgress);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: color),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 5,
                    backgroundColor: isDark ? Colors.white12 : Colors.grey.shade100,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

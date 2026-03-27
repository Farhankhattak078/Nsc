import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../widgets/onboarding_page.dart';
import '../screens/login_screen.dart';
import '../services/storage_service.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const OnboardingScreen({super.key, required this.onComplete});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}


class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _goToLogin();
    }
  }

  void _skip() {
    _goToLogin();
  }

  void _goToLogin() async {
    await StorageService().setOnboardingSeen();
    widget.onComplete();
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Modern Background Decorations
          Positioned(
            top: -100,
            right: -100,
            child: _DecorativeBlob(
              color: const Color(0xFF7C5DFA).withValues(alpha: 0.1),
              size: 300,
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: _DecorativeBlob(
              color: const Color(0xFF7C5DFA).withValues(alpha: 0.05),
              size: 250,
            ),
          ),

          // Main Content
          Column(
            children: [
              // Top Bar (Skip)
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: _skip,
                      style: TextButton.styleFrom(
                        foregroundColor: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                      ),
                      child: Text(
                        'Skip',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // PageView
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  children: [
                    OnboardingPage(
                      title: 'Master Your Skills',
                      description: 'Test your knowledge with 1000+ hand-picked professional questions across various tech domains.',
                      illustration: Image.asset(
                        'assets/images/onboarding_study.png',
                        height: 280,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => _FallbackIllustration(
                          icon: LucideIcons.graduationCap,
                          color: theme.primaryColor,
                        ),
                      ),
                    ),
                    const OnboardingPage(
                      title: 'Smart Categorization',
                      description: 'From Networking to Web Development, find structured MCQs designed to challenge your understanding.',
                      icon: LucideIcons.layoutGrid,
                    ),
                    const OnboardingPage(
                      title: 'Achieve Excellence',
                      description: 'Track your performance, review mistakes, and climb the leaderboard as you aim for the perfect score.',
                      icon: LucideIcons.trophy,
                    ),
                  ],
                ),
              ),

              // Bottom Controls
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(32, 0, 32, 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Animated Pagination Dots
                      Row(
                        children: List.generate(
                          3,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.only(right: 8),
                            height: 8,
                            width: _currentPage == index ? 24 : 8,
                            decoration: BoxDecoration(
                              color: _currentPage == index
                                  ? theme.primaryColor
                                  : theme.primaryColor.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),

                      // Next / Get Started Button
                      GestureDetector(
                        onTap: _nextPage,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: EdgeInsets.symmetric(
                            horizontal: _currentPage == 2 ? 32 : 20,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: theme.primaryColor,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: theme.primaryColor.withValues(alpha: 0.3),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _currentPage == 2 ? 'Get Started' : 'Next',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              if (_currentPage < 2) ...[
                                const SizedBox(width: 8),
                                const Icon(LucideIcons.arrowRight, size: 18, color: Colors.white),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DecorativeBlob extends StatelessWidget {
  final Color color;
  final double size;

  const _DecorativeBlob({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _FallbackIllustration extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _FallbackIllustration({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      height: 220,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(icon, size: 100, color: color),
      ),
    );
  }
}

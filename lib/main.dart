import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nsct/theme/app_theme.dart';
import 'package:nsct/screens/home_screen.dart';
import 'package:nsct/screens/login_screen.dart';
import 'package:nsct/screens/onboarding_screen.dart';
import 'package:nsct/services/storage_service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  await Firebase.initializeApp();

  await StorageService().init();
  runApp(const SkillTestPrepApp());
}

// InheritedWidget to propagate the toggleTheme callback without exposing
// the private state class.
class AppThemeController extends InheritedWidget {
  final VoidCallback toggleTheme;
  final bool isDark;

  const AppThemeController({
    super.key,
    required this.toggleTheme,
    required this.isDark,
    required super.child,
  });

  static AppThemeController of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<AppThemeController>();
    assert(result != null, 'No AppThemeController found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(AppThemeController oldWidget) =>
      isDark != oldWidget.isDark;
}

class SkillTestPrepApp extends StatefulWidget {
  const SkillTestPrepApp({super.key});

  @override
  State<SkillTestPrepApp> createState() => _SkillTestPrepAppState();
}

class _SkillTestPrepAppState extends State<SkillTestPrepApp> {
  ThemeMode _themeMode = ThemeMode.system;
  final ValueNotifier<bool> _onboardingComplete = ValueNotifier<bool>(false);
  late Stream<User?> _authStateStream;

  @override
  void initState() {
    super.initState();
    _authStateStream = FirebaseAuth.instance.authStateChanges();
    // Initialize onboarding state from storage
    _onboardingComplete.value = StorageService().hasSeenOnboarding;
  }

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  bool get _isDark {
    if (_themeMode == ThemeMode.system) {
      return WidgetsBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }

  @override
  Widget build(BuildContext context) {
    return AppThemeController(
      toggleTheme: _toggleTheme,
      isDark: _isDark,
      child: MaterialApp(
        title: 'NSCT Prep',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: _themeMode,
        home: ValueListenableBuilder<bool>(
          valueListenable: _onboardingComplete,
          builder: (context, hasSeenOnboarding, _) {
            return StreamBuilder<User?>(
              stream: _authStateStream,
              builder: (context, snapshot) {
                // Use AnimatedSwitcher for premium feel transitions
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: _getScreen(snapshot, hasSeenOnboarding),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _getScreen(AsyncSnapshot<User?> snapshot, bool hasSeenOnboarding) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      final isDark = _isDark;
      return Scaffold(
        key: const ValueKey('loading'),
        backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo with subtle animation feel (Scale)
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.8, end: 1.0),
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutBack,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: child,
                  );
                },
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4F46E5).withValues(alpha: 0.15),
                        blurRadius: 30,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/app_icon.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // App Name
              Text(
                'NSCT PREP',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Master Your Skills',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.grey,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 64),
              // Modern loader
              SizedBox(
                width: 40,
                height: 2,
                child: LinearProgressIndicator(
                  backgroundColor: isDark 
                      ? Colors.white.withValues(alpha:0.1) 
                      : const Color(0xFF4F46E5).withValues(alpha:0.1),
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4F46E5)),
                ),
              ),
            ],
          ),
        ),
      );
    }
    
    // 1. If logged in, go to Home
    if (snapshot.hasData && snapshot.data != null) {
      return const HomeScreen(key: ValueKey('home'));
    }
    
    // 2. If not logged in and hasn't seen onboarding, go to Onboarding
    if (!hasSeenOnboarding) {
      return OnboardingScreen(
        key: const ValueKey('onboarding'),
        onComplete: () {
          _onboardingComplete.value = true;
        },
      );
    }
    
    // 3. Otherwise, go to Login
    return const LoginScreen(key: ValueKey('login'));
  }
}


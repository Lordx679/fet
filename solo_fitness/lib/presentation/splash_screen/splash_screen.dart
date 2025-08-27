import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/animated_logo_widget.dart';
import './widgets/floating_particles_widget.dart';
import './widgets/loading_indicator_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late Animation<Color?> _backgroundAnimation;

  bool _isInitializing = true;
  String _currentLoadingText = 'Initializing RPG Systems...';

  final List<String> _loadingMessages = [
    'Initializing RPG Systems...',
    'Loading User Profile...',
    'Preparing Daily Quests...',
    'Syncing Workout Data...',
    'Ready for Adventure!',
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startInitialization();
  }

  void _initializeAnimations() {
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _backgroundAnimation = ColorTween(
      begin: AppTheme.backgroundDeep,
      end: AppTheme.backgroundMid,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    ));

    _backgroundController.repeat(reverse: true);
  }

  Future<void> _startInitialization() async {
    try {
      // Simulate initialization process with realistic loading messages
      for (int i = 0; i < _loadingMessages.length; i++) {
        if (mounted) {
          setState(() {
            _currentLoadingText = _loadingMessages[i];
          });
        }

        await Future.delayed(Duration(milliseconds: 600 + (i * 100)));
      }

      // Check authentication status and user data
      await _checkUserStatus();
    } catch (e) {
      // Handle initialization errors gracefully
      if (mounted) {
        setState(() {
          _currentLoadingText = 'Connection timeout. Retrying...';
        });
      }

      // Retry after 2 seconds
      await Future.delayed(const Duration(seconds: 2));
      await _checkUserStatus();
    }
  }

  Future<void> _checkUserStatus() async {
    if (!mounted) return;

    // Add haptic feedback for better UX
    HapticFeedback.lightImpact();

    // Simulate checking user authentication and onboarding status
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      // Mock user status check - in real app this would check:
      // - Google OAuth authentication status
      // - User onboarding completion
      // - Cached user data availability

      final bool isAuthenticated = _mockCheckAuthentication();
      final bool hasCompletedOnboarding = _mockCheckOnboarding();

      if (isAuthenticated && hasCompletedOnboarding) {
        // Navigate to main dashboard for returning users
        _navigateToNextScreen('/workout-timer-screen');
      } else if (isAuthenticated && !hasCompletedOnboarding) {
        // Navigate to onboarding for authenticated but new users
        _navigateToNextScreen('/user-onboarding-screen');
      } else {
        // Navigate to login for non-authenticated users
        _navigateToNextScreen('/google-login-screen');
      }
    }
  }

  bool _mockCheckAuthentication() {
    // Mock authentication check - returns false to show login flow
    // In real implementation, this would check stored auth tokens
    return false;
  }

  bool _mockCheckOnboarding() {
    // Mock onboarding check
    // In real implementation, this would check user profile completion
    return false;
  }

  void _navigateToNextScreen(String route) {
    if (!mounted) return;

    // Add smooth transition with fade effect
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, route);
      }
    });
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundController,
        builder: (context, child) {
          return Container(
            width: 100.w,
            height: 100.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  _backgroundAnimation.value ?? AppTheme.backgroundDeep,
                  AppTheme.backgroundDeep,
                  AppTheme.backgroundMid.withValues(alpha: 0.3),
                ],
                stops: const [0.0, 0.7, 1.0],
              ),
            ),
            child: SafeArea(
              child: Stack(
                children: [
                  // Floating particles background
                  const Positioned.fill(
                    child: FloatingParticlesWidget(),
                  ),

                  // Main content
                  Positioned.fill(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Spacer to push content up slightly
                        SizedBox(height: 10.h),

                        // Animated logo
                        const AnimatedLogoWidget(),

                        // Spacer between logo and loading indicator
                        SizedBox(height: 15.h),

                        // Loading indicator
                        LoadingIndicatorWidget(
                          loadingText: _currentLoadingText,
                        ),

                        // Bottom spacer
                        SizedBox(height: 10.h),
                      ],
                    ),
                  ),

                  // Version info at bottom
                  Positioned(
                    bottom: 5.h,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        Text(
                          'Version 1.0.0',
                          style:
                              AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                            color:
                                AppTheme.textSecondary.withValues(alpha: 0.6),
                            fontSize: 10.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'Transform Your Fitness Journey',
                          style:
                              AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                            color:
                                AppTheme.textSecondary.withValues(alpha: 0.8),
                            fontSize: 11.sp,
                            letterSpacing: 0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/animated_background.dart';
import './widgets/character_preview.dart';
import './widgets/fitness_goals_selection.dart';
import './widgets/fitness_level_selection.dart';
import './widgets/onboarding_progress_indicator.dart';
import './widgets/personal_metrics_form.dart';

class UserOnboardingScreen extends StatefulWidget {
  const UserOnboardingScreen({Key? key}) : super(key: key);

  @override
  State<UserOnboardingScreen> createState() => _UserOnboardingScreenState();
}

class _UserOnboardingScreenState extends State<UserOnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  late AnimationController _slideController;
  late AnimationController _buttonController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _buttonScaleAnimation;

  int _currentStep = 0;
  final int _totalSteps = 4;
  bool _isLoading = false;

  // User data collection
  Map<String, dynamic> _userData = {
    'weight': null,
    'height': null,
    'age': null,
    'gender': 'Male',
    'fitnessLevel': null,
    'goals': <String>[],
  };

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOut,
    ));

    _buttonScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _buttonController,
      curve: Curves.easeInOut,
    ));

    _slideController.forward();
  }

  bool _canProceedToNextStep() {
    switch (_currentStep) {
      case 0:
        return _userData['weight'] != null &&
            _userData['height'] != null &&
            _userData['age'] != null &&
            _userData['gender'] != null;
      case 1:
        return _userData['fitnessLevel'] != null;
      case 2:
        return (_userData['goals'] as List<String>).isNotEmpty;
      case 3:
        return true;
      default:
        return false;
    }
  }

  void _nextStep() async {
    if (!_canProceedToNextStep()) return;

    _buttonController.forward().then((_) {
      _buttonController.reverse();
    });

    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
      });

      await _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _previousStep() async {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });

      await _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _completeOnboarding() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate data processing
    await Future.delayed(const Duration(seconds: 2));

    // Navigate to main app (dashboard would be implemented separately)
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    }
  }

  void _updatePersonalMetrics(Map<String, dynamic> data) {
    setState(() {
      _userData.addAll(data);
    });
  }

  void _updateFitnessLevel(String level) {
    setState(() {
      _userData['fitnessLevel'] = level;
    });
  }

  void _updateGoals(List<String> goals) {
    setState(() {
      _userData['goals'] = goals;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDeep,
      body: SafeArea(
        child: AnimatedBackground(
          child: Column(
            children: [
              // Progress Indicator
              OnboardingProgressIndicator(
                currentStep: _currentStep,
                totalSteps: _totalSteps,
              ),

              // Content Area
              Expanded(
                child: SlideTransition(
                  position: _slideAnimation,
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      // Step 1: Personal Metrics
                      SingleChildScrollView(
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        child: PersonalMetricsForm(
                          onDataChanged: _updatePersonalMetrics,
                          initialData: _userData,
                        ),
                      ),

                      // Step 2: Fitness Level
                      SingleChildScrollView(
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        child: FitnessLevelSelection(
                          onLevelSelected: _updateFitnessLevel,
                          selectedLevel: _userData['fitnessLevel'],
                        ),
                      ),

                      // Step 3: Goals Selection
                      SingleChildScrollView(
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        child: FitnessGoalsSelection(
                          onGoalsChanged: _updateGoals,
                          selectedGoals: _userData['goals'] as List<String>,
                        ),
                      ),

                      // Step 4: Character Preview
                      SingleChildScrollView(
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        child: CharacterPreview(
                          userData: _userData,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Navigation Buttons
              _buildNavigationButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      width: 90.w,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        children: [
          // Back Button
          if (_currentStep > 0)
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: _previousStep,
                child: Container(
                  height: 6.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.textSecondary.withValues(alpha: 0.3),
                      width: 1,
                    ),
                    color: AppTheme.backgroundMid,
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'arrow_back',
                          color: AppTheme.textSecondary,
                          size: 5.w,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Back',
                          style:
                              AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          if (_currentStep > 0) SizedBox(width: 4.w),

          // Next/Complete Button
          Expanded(
            flex: _currentStep > 0 ? 2 : 1,
            child: AnimatedBuilder(
              animation: _buttonScaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _buttonScaleAnimation.value,
                  child: GestureDetector(
                    onTap: _canProceedToNextStep() ? _nextStep : null,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 6.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: _canProceedToNextStep()
                            ? LinearGradient(
                                colors: [
                                  AppTheme.primaryBlue,
                                  AppTheme.secondaryPurple,
                                ],
                              )
                            : null,
                        color: _canProceedToNextStep()
                            ? null
                            : AppTheme.textSecondary.withValues(alpha: 0.3),
                        boxShadow: _canProceedToNextStep()
                            ? [
                                BoxShadow(
                                  color: AppTheme.primaryBlue
                                      .withValues(alpha: 0.4),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : null,
                      ),
                      child: Center(
                        child: _isLoading
                            ? SizedBox(
                                width: 5.w,
                                height: 5.w,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppTheme.textPrimary,
                                  ),
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _currentStep == _totalSteps - 1
                                        ? 'Start Journey'
                                        : 'Next',
                                    style: AppTheme
                                        .darkTheme.textTheme.labelLarge
                                        ?.copyWith(
                                      color: _canProceedToNextStep()
                                          ? AppTheme.textPrimary
                                          : AppTheme.textSecondary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: 2.w),
                                  CustomIconWidget(
                                    iconName: _currentStep == _totalSteps - 1
                                        ? 'rocket_launch'
                                        : 'arrow_forward',
                                    color: _canProceedToNextStep()
                                        ? AppTheme.textPrimary
                                        : AppTheme.textSecondary,
                                    size: 5.w,
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _slideController.dispose();
    _buttonController.dispose();
    super.dispose();
  }
}

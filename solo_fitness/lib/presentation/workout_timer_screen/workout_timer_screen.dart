import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/control_buttons_widget.dart';
import './widgets/exercise_info_widget.dart';
import './widgets/floating_timer_widget.dart';
import './widgets/timer_display_widget.dart';
import './widgets/workout_progress_widget.dart';

class WorkoutTimerScreen extends StatefulWidget {
  const WorkoutTimerScreen({Key? key}) : super(key: key);

  @override
  State<WorkoutTimerScreen> createState() => _WorkoutTimerScreenState();
}

class _WorkoutTimerScreenState extends State<WorkoutTimerScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  // Timer state
  Timer? _timer;
  int _remainingSeconds = 45;
  int _totalSeconds = 45;
  bool _isActive = false;
  bool _isResting = false;
  bool _isMinimized = false;

  // Workout state
  int _currentExercise = 1;
  int _totalExercises = 8;
  int _currentSet = 1;
  int _totalSets = 3;
  int _repsPerSet = 12;
  int _completedSets = 0;
  int _earnedXP = 0;
  int _restDuration = 30;
  int _workDuration = 45;

  // Animation controllers
  late AnimationController _xpAnimationController;
  late AnimationController _backgroundController;
  late Animation<Color?> _backgroundAnimation;

  // Mock workout data
  final List<Map<String, dynamic>> _workoutExercises = [
    {
      "id": 1,
      "name": "Push-ups",
      "image":
          "https://images.pexels.com/photos/416809/pexels-photo-416809.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "sets": 3,
      "reps": 12,
      "duration": 45,
      "restDuration": 30,
      "xpReward": 15,
    },
    {
      "id": 2,
      "name": "Squats",
      "image":
          "https://images.pexels.com/photos/4162449/pexels-photo-4162449.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "sets": 3,
      "reps": 15,
      "duration": 50,
      "restDuration": 35,
      "xpReward": 18,
    },
    {
      "id": 3,
      "name": "Plank Hold",
      "image":
          "https://images.pexels.com/photos/4056723/pexels-photo-4056723.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "sets": 3,
      "reps": 1,
      "duration": 60,
      "restDuration": 40,
      "xpReward": 20,
    },
    {
      "id": 4,
      "name": "Burpees",
      "image":
          "https://images.pexels.com/photos/4162492/pexels-photo-4162492.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "sets": 3,
      "reps": 10,
      "duration": 40,
      "restDuration": 45,
      "xpReward": 25,
    },
    {
      "id": 5,
      "name": "Mountain Climbers",
      "image":
          "https://images.pexels.com/photos/4162438/pexels-photo-4162438.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "sets": 3,
      "reps": 20,
      "duration": 35,
      "restDuration": 30,
      "xpReward": 16,
    },
    {
      "id": 6,
      "name": "Lunges",
      "image":
          "https://images.pexels.com/photos/4162451/pexels-photo-4162451.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "sets": 3,
      "reps": 12,
      "duration": 45,
      "restDuration": 30,
      "xpReward": 17,
    },
    {
      "id": 7,
      "name": "Jumping Jacks",
      "image":
          "https://images.pexels.com/photos/4162519/pexels-photo-4162519.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "sets": 3,
      "reps": 25,
      "duration": 40,
      "restDuration": 25,
      "xpReward": 14,
    },
    {
      "id": 8,
      "name": "Dead Bug",
      "image":
          "https://images.pexels.com/photos/4162440/pexels-photo-4162440.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "sets": 3,
      "reps": 10,
      "duration": 50,
      "restDuration": 35,
      "xpReward": 19,
    },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeAnimations();
    _loadCurrentExercise();
    _preventScreenLock();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _xpAnimationController.dispose();
    _backgroundController.dispose();
    _allowScreenLock();
    super.dispose();
  }

  void _initializeAnimations() {
    _xpAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _backgroundAnimation = ColorTween(
      begin: AppTheme.backgroundDeep,
      end: AppTheme.backgroundMid,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    ));
  }

  void _preventScreenLock() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
  }

  void _allowScreenLock() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
  }

  void _loadCurrentExercise() {
    if (_currentExercise <= _workoutExercises.length) {
      final exercise = _workoutExercises[_currentExercise - 1];
      setState(() {
        _totalSets = exercise["sets"] as int;
        _repsPerSet = exercise["reps"] as int;
        _workDuration = exercise["duration"] as int;
        _restDuration = exercise["restDuration"] as int;
        _totalSeconds = _workDuration;
        _remainingSeconds = _workDuration;
      });
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _onTimerComplete();
      }
    });

    setState(() {
      _isActive = true;
    });

    _backgroundController.forward();
    HapticFeedback.lightImpact();
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _isActive = false;
    });

    _backgroundController.reverse();
    HapticFeedback.mediumImpact();
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isActive = false;
      _remainingSeconds = _isResting ? _restDuration : _workDuration;
      _totalSeconds = _isResting ? _restDuration : _workDuration;
    });

    _backgroundController.reverse();
    HapticFeedback.heavyImpact();
  }

  void _onTimerComplete() {
    _timer?.cancel();

    if (_isResting) {
      // Rest complete, start next set
      setState(() {
        _isResting = false;
        _isActive = false;
        _totalSeconds = _workDuration;
        _remainingSeconds = _workDuration;
      });
    } else {
      // Work set complete
      _completeSet();
    }

    HapticFeedback.heavyImpact();
    _showCompletionAnimation();
  }

  void _completeSet() {
    final exercise = _workoutExercises[_currentExercise - 1];
    final xpGained = (exercise["xpReward"] as int);

    setState(() {
      _completedSets++;
      _earnedXP += xpGained;
    });

    if (_currentSet < _totalSets) {
      // Start rest period
      setState(() {
        _currentSet++;
        _isResting = true;
        _isActive = false;
        _totalSeconds = _restDuration;
        _remainingSeconds = _restDuration;
      });
    } else {
      // Exercise complete, move to next
      _nextExercise();
    }
  }

  void _nextExercise() {
    if (_currentExercise < _totalExercises) {
      setState(() {
        _currentExercise++;
        _currentSet = 1;
        _isResting = false;
        _isActive = false;
      });
      _loadCurrentExercise();
    } else {
      _completeWorkout();
    }
  }

  void _previousExercise() {
    if (_currentExercise > 1) {
      setState(() {
        _currentExercise--;
        _currentSet = 1;
        _isResting = false;
        _isActive = false;
      });
      _loadCurrentExercise();
    }
  }

  void _completeWorkout() {
    _timer?.cancel();
    setState(() {
      _isActive = false;
    });

    // Show completion dialog
    _showWorkoutCompleteDialog();
  }

  void _showCompletionAnimation() {
    _xpAnimationController.forward().then((_) {
      _xpAnimationController.reset();
    });
  }

  void _showWorkoutCompleteDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.backgroundMid,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: AppTheme.accentGold.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'emoji_events',
              color: AppTheme.accentGold,
              size: 8.w,
            ),
            SizedBox(width: 3.w),
            Text(
              'Workout Complete!',
              style: AppTheme.darkTheme.textTheme.headlineSmall?.copyWith(
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Congratulations! You\'ve completed your workout and earned $_earnedXP XP points.',
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.accentGold.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.accentGold.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'star',
                    color: AppTheme.accentGold,
                    size: 6.w,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    '+$_earnedXP XP',
                    style: AppTheme.dataDisplayMedium.copyWith(
                      color: AppTheme.accentGold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text(
              'Continue',
              style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.primaryBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showInstructions() {
    final exercise = _workoutExercises[_currentExercise - 1];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: 60.h,
        decoration: BoxDecoration(
          color: AppTheme.backgroundMid,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          border: Border.all(
            color: AppTheme.primaryBlue.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: EdgeInsets.only(top: 2.h),
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.textSecondary.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            SizedBox(height: 3.h),

            // Exercise image
            Container(
              width: 80.w,
              height: 30.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.primaryBlue.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CustomImageWidget(
                  imageUrl: exercise["image"] as String,
                  width: 80.w,
                  height: 30.h,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            SizedBox(height: 3.h),

            // Exercise details
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: Column(
                children: [
                  Text(
                    exercise["name"] as String,
                    style: AppTheme.darkTheme.textTheme.headlineSmall?.copyWith(
                      color: AppTheme.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Perform ${exercise["reps"]} reps for ${exercise["sets"]} sets with ${exercise["restDuration"]} seconds rest between sets.',
                    style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
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
  }

  void _toggleMinimized() {
    setState(() {
      _isMinimized = !_isMinimized;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentExerciseData = _workoutExercises[_currentExercise - 1];

    return Scaffold(
      backgroundColor: AppTheme.backgroundDeep,
      body: AnimatedBuilder(
        animation: _backgroundAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  _backgroundAnimation.value ?? AppTheme.backgroundDeep,
                  AppTheme.backgroundDeep,
                ],
              ),
            ),
            child: SafeArea(
              child: Stack(
                children: [
                  // Main content
                  if (!_isMinimized)
                    Column(
                      children: [
                        // Header with close button
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.w, vertical: 2.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.of(context).pop(),
                                child: Container(
                                  padding: EdgeInsets.all(2.w),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppTheme.backgroundMid,
                                    border: Border.all(
                                      color: AppTheme.textSecondary
                                          .withValues(alpha: 0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: CustomIconWidget(
                                    iconName: 'close',
                                    color: AppTheme.textSecondary,
                                    size: 6.w,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: _toggleMinimized,
                                child: Container(
                                  padding: EdgeInsets.all(2.w),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppTheme.backgroundMid,
                                    border: Border.all(
                                      color: AppTheme.primaryBlue
                                          .withValues(alpha: 0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: CustomIconWidget(
                                    iconName: 'minimize',
                                    color: AppTheme.primaryBlue,
                                    size: 6.w,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Exercise info
                        ExerciseInfoWidget(
                          exerciseName: currentExerciseData["name"] as String,
                          currentSet: _currentSet,
                          totalSets: _totalSets,
                          repsPerSet: _repsPerSet,
                          exerciseImage: currentExerciseData["image"] as String,
                          onShowInstructions: _showInstructions,
                        ),

                        SizedBox(height: 2.h),

                        // Timer display
                        TimerDisplayWidget(
                          totalSeconds: _totalSeconds,
                          remainingSeconds: _remainingSeconds,
                          isActive: _isActive,
                          isResting: _isResting,
                          onTimerComplete: _onTimerComplete,
                        ),

                        SizedBox(height: 3.h),

                        // Control buttons
                        ControlButtonsWidget(
                          isPlaying: _isActive,
                          canGoNext: _currentExercise < _totalExercises,
                          canGoPrevious: _currentExercise > 1,
                          onPlayPause: _isActive ? _pauseTimer : _startTimer,
                          onNext: _nextExercise,
                          onPrevious: _previousExercise,
                          onReset: _resetTimer,
                        ),

                        const Spacer(),

                        // Workout progress
                        WorkoutProgressWidget(
                          currentExercise: _currentExercise,
                          totalExercises: _totalExercises,
                          completedSets: _completedSets,
                          totalSets: _totalSets * _totalExercises,
                          earnedXP: _earnedXP,
                        ),

                        SizedBox(height: 2.h),
                      ],
                    ),

                  // Floating timer widget
                  if (_isMinimized)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: FloatingTimerWidget(
                        remainingSeconds: _remainingSeconds,
                        isActive: _isActive,
                        isResting: _isResting,
                        exerciseName: currentExerciseData["name"] as String,
                        onTap: _toggleMinimized,
                        onClose: () => Navigator.of(context).pop(),
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

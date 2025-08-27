import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FitnessGoalsSelection extends StatefulWidget {
  final Function(List<String>) onGoalsChanged;
  final List<String> selectedGoals;

  const FitnessGoalsSelection({
    Key? key,
    required this.onGoalsChanged,
    required this.selectedGoals,
  }) : super(key: key);

  @override
  State<FitnessGoalsSelection> createState() => _FitnessGoalsSelectionState();
}

class _FitnessGoalsSelectionState extends State<FitnessGoalsSelection>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  final List<Map<String, dynamic>> _fitnessGoals = [
    {
      'id': 'strength',
      'title': 'Build Strength',
      'description': 'Increase muscle mass and power',
      'icon': 'fitness_center',
      'color': AppTheme.errorRed,
    },
    {
      'id': 'cardio',
      'title': 'Improve Cardio',
      'description': 'Boost endurance and heart health',
      'icon': 'directions_run',
      'color': AppTheme.primaryBlue,
    },
    {
      'id': 'weight_loss',
      'title': 'Lose Weight',
      'description': 'Burn calories and reduce body fat',
      'icon': 'trending_down',
      'color': AppTheme.successGreen,
    },
    {
      'id': 'flexibility',
      'title': 'Flexibility',
      'description': 'Improve mobility and range of motion',
      'icon': 'self_improvement',
      'color': AppTheme.secondaryPurple,
    },
    {
      'id': 'muscle_gain',
      'title': 'Gain Muscle',
      'description': 'Build lean muscle mass',
      'icon': 'sports_gymnastics',
      'color': AppTheme.accentGold,
    },
    {
      'id': 'general_fitness',
      'title': 'General Fitness',
      'description': 'Overall health and wellness',
      'icon': 'favorite',
      'color': AppTheme.warningOrange,
    },
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    _pulseController.repeat(reverse: true);
  }

  void _toggleGoal(String goalId) {
    List<String> updatedGoals = List.from(widget.selectedGoals);

    if (updatedGoals.contains(goalId)) {
      updatedGoals.remove(goalId);
    } else {
      updatedGoals.add(goalId);
    }

    widget.onGoalsChanged(updatedGoals);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.w,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Your Quests',
            style: AppTheme.darkTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.primaryBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Choose your fitness goals to unlock targeted challenges',
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            'Select multiple goals that match your objectives',
            style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondary.withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: 3.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 3.w,
              mainAxisSpacing: 2.h,
              childAspectRatio: 0.85,
            ),
            itemCount: _fitnessGoals.length,
            itemBuilder: (context, index) {
              final goal = _fitnessGoals[index];
              final isSelected = widget.selectedGoals.contains(goal['id']);

              return AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: isSelected ? _pulseAnimation.value : 1.0,
                    child: _buildGoalCard(goal, isSelected),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGoalCard(Map<String, dynamic> goal, bool isSelected) {
    return GestureDetector(
      onTap: () => _toggleGoal(goal['id'] as String),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? (goal['color'] as Color)
                : AppTheme.textSecondary.withValues(alpha: 0.2),
            width: isSelected ? 2 : 1,
          ),
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    (goal['color'] as Color).withValues(alpha: 0.2),
                    AppTheme.backgroundMid,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : AppTheme.backgroundMid,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: (goal['color'] as Color).withValues(alpha: 0.4),
                    blurRadius: 12,
                    spreadRadius: 1,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (goal['color'] as Color).withValues(alpha: 0.2),
                border: Border.all(
                  color: goal['color'] as Color,
                  width: 2,
                ),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: goal['icon'] as String,
                  color: goal['color'] as Color,
                  size: 6.w,
                ),
              ),
            ),
            SizedBox(height: 1.5.h),
            Text(
              goal['title'] as String,
              style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                color: isSelected
                    ? (goal['color'] as Color)
                    : AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 0.5.h),
            Text(
              goal['description'] as String,
              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
                fontSize: 9.sp,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (isSelected) ...[
              SizedBox(height: 1.h),
              CustomIconWidget(
                iconName: 'check_circle',
                color: goal['color'] as Color,
                size: 5.w,
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }
}

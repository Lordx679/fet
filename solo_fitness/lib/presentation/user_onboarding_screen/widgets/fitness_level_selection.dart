import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FitnessLevelSelection extends StatefulWidget {
  final Function(String) onLevelSelected;
  final String? selectedLevel;

  const FitnessLevelSelection({
    Key? key,
    required this.onLevelSelected,
    this.selectedLevel,
  }) : super(key: key);

  @override
  State<FitnessLevelSelection> createState() => _FitnessLevelSelectionState();
}

class _FitnessLevelSelectionState extends State<FitnessLevelSelection>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  final List<Map<String, dynamic>> _fitnessLevels = [
    {
      'level': 'Novice',
      'title': 'Novice Adventurer',
      'description': 'Just starting your fitness journey',
      'icon': 'person',
      'color': AppTheme.successGreen,
      'xp': '0-500 XP',
    },
    {
      'level': 'Apprentice',
      'title': 'Apprentice Warrior',
      'description': 'Some experience with regular workouts',
      'icon': 'fitness_center',
      'color': AppTheme.primaryBlue,
      'xp': '500-2000 XP',
    },
    {
      'level': 'Warrior',
      'title': 'Elite Warrior',
      'description': 'Advanced fitness enthusiast',
      'icon': 'military_tech',
      'color': AppTheme.accentGold,
      'xp': '2000+ XP',
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
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
            'Choose Your Class',
            style: AppTheme.darkTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.primaryBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Select your current fitness level to unlock appropriate challenges',
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          SizedBox(height: 3.h),
          ...(_fitnessLevels.asMap().entries.map((entry) {
            final index = entry.key;
            final level = entry.value;
            return AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 2.h),
                    child: _buildLevelCard(level, index),
                  ),
                );
              },
            );
          }).toList()),
        ],
      ),
    );
  }

  Widget _buildLevelCard(Map<String, dynamic> level, int index) {
    final isSelected = widget.selectedLevel == level['level'];

    return GestureDetector(
      onTap: () {
        widget.onLevelSelected(level['level'] as String);
        _animateSelection();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? (level['color'] as Color)
                : AppTheme.textSecondary.withValues(alpha: 0.2),
            width: isSelected ? 2 : 1,
          ),
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    (level['color'] as Color).withValues(alpha: 0.1),
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
                    color: (level['color'] as Color).withValues(alpha: 0.3),
                    blurRadius: 12,
                    spreadRadius: 2,
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
        child: Row(
          children: [
            Container(
              width: 15.w,
              height: 15.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (level['color'] as Color).withValues(alpha: 0.2),
                border: Border.all(
                  color: level['color'] as Color,
                  width: 2,
                ),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: level['icon'] as String,
                  color: level['color'] as Color,
                  size: 7.w,
                ),
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    level['title'] as String,
                    style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                      color: isSelected
                          ? (level['color'] as Color)
                          : AppTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    level['description'] as String,
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 2.w,
                      vertical: 0.5.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: (level['color'] as Color).withValues(alpha: 0.1),
                    ),
                    child: Text(
                      level['xp'] as String,
                      style: AppTheme.dataDisplaySmall.copyWith(
                        fontSize: 10.sp,
                        color: level['color'] as Color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              CustomIconWidget(
                iconName: 'check_circle',
                color: level['color'] as Color,
                size: 6.w,
              ),
          ],
        ),
      ),
    );
  }

  void _animateSelection() {
    _animationController.reset();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

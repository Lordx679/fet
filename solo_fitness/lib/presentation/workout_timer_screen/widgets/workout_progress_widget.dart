import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class WorkoutProgressWidget extends StatelessWidget {
  final int currentExercise;
  final int totalExercises;
  final int completedSets;
  final int totalSets;
  final int earnedXP;

  const WorkoutProgressWidget({
    Key? key,
    required this.currentExercise,
    required this.totalExercises,
    required this.completedSets,
    required this.totalSets,
    required this.earnedXP,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final exerciseProgress =
        totalExercises > 0 ? currentExercise / totalExercises : 0.0;
    final setProgress = totalSets > 0 ? completedSets / totalSets : 0.0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      child: Column(
        children: [
          // Exercise progress
          Row(
            children: [
              CustomIconWidget(
                iconName: 'fitness_center',
                color: AppTheme.primaryBlue,
                size: 5.w,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Exercise Progress',
                          style: AppTheme.darkTheme.textTheme.labelMedium
                              ?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        Text(
                          '$currentExercise / $totalExercises',
                          style: AppTheme.darkTheme.textTheme.labelMedium
                              ?.copyWith(
                            color: AppTheme.primaryBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    _buildProgressBar(exerciseProgress, AppTheme.primaryBlue),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Set progress
          Row(
            children: [
              CustomIconWidget(
                iconName: 'repeat',
                color: AppTheme.secondaryPurple,
                size: 5.w,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Set Progress',
                          style: AppTheme.darkTheme.textTheme.labelMedium
                              ?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        Text(
                          '$completedSets / $totalSets',
                          style: AppTheme.darkTheme.textTheme.labelMedium
                              ?.copyWith(
                            color: AppTheme.secondaryPurple,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    _buildProgressBar(setProgress, AppTheme.secondaryPurple),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // XP earned
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.backgroundMid,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.accentGold.withValues(alpha: 0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.shadowGold,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
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
                  'XP Earned: ',
                  style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                Text(
                  '$earnedXP',
                  style: AppTheme.dataDisplaySmall.copyWith(
                    color: AppTheme.accentGold,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(double progress, Color color) {
    return Container(
      height: 1.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: AppTheme.backgroundMid,
      ),
      child: Stack(
        children: [
          Container(
            height: 1.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: color.withValues(alpha: 0.2),
            ),
          ),
          FractionallySizedBox(
            widthFactor: progress.clamp(0.0, 1.0),
            child: Container(
              height: 1.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                gradient: LinearGradient(
                  colors: [
                    color,
                    color.withValues(alpha: 0.8),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

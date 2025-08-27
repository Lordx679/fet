import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ExerciseInfoWidget extends StatelessWidget {
  final String exerciseName;
  final int currentSet;
  final int totalSets;
  final int repsPerSet;
  final String? exerciseImage;
  final VoidCallback? onShowInstructions;

  const ExerciseInfoWidget({
    Key? key,
    required this.exerciseName,
    required this.currentSet,
    required this.totalSets,
    required this.repsPerSet,
    this.exerciseImage,
    this.onShowInstructions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
      child: Column(
        children: [
          // Exercise name
          Text(
            exerciseName,
            style: AppTheme.darkTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: 2.h),

          // Exercise image with instruction button
          if (exerciseImage != null)
            GestureDetector(
              onTap: onShowInstructions,
              child: Container(
                width: 25.w,
                height: 25.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.primaryBlue.withValues(alpha: 0.3),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.shadowBlue,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CustomImageWidget(
                        imageUrl: exerciseImage!,
                        width: 25.w,
                        height: 25.w,
                        fit: BoxFit.cover,
                      ),
                    ),

                    // Overlay with instruction icon
                    Container(
                      width: 25.w,
                      height: 25.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppTheme.backgroundDeep.withValues(alpha: 0.6),
                      ),
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTheme.primaryBlue.withValues(alpha: 0.2),
                            border: Border.all(
                              color: AppTheme.primaryBlue,
                              width: 1,
                            ),
                          ),
                          child: CustomIconWidget(
                            iconName: 'play_arrow',
                            color: AppTheme.primaryBlue,
                            size: 6.w,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          SizedBox(height: 3.h),

          // Set and rep information
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.backgroundMid,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.primaryBlue.withValues(alpha: 0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.shadowBlue,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Current set
                Column(
                  children: [
                    Text(
                      'SET',
                      style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.textSecondary,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: currentSet.toString(),
                            style: AppTheme.dataDisplayMedium.copyWith(
                              color: AppTheme.primaryBlue,
                            ),
                          ),
                          TextSpan(
                            text: ' / $totalSets',
                            style: AppTheme.darkTheme.textTheme.titleMedium
                                ?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Divider
                Container(
                  height: 6.h,
                  width: 1,
                  color: AppTheme.textSecondary.withValues(alpha: 0.2),
                ),

                // Reps
                Column(
                  children: [
                    Text(
                      'REPS',
                      style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.textSecondary,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      repsPerSet.toString(),
                      style: AppTheme.dataDisplayMedium.copyWith(
                        color: AppTheme.accentGold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

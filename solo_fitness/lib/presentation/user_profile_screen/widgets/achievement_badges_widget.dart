import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AchievementBadgesWidget extends StatefulWidget {
  final List<Map<String, dynamic>> achievements;

  const AchievementBadgesWidget({
    Key? key,
    required this.achievements,
  }) : super(key: key);

  @override
  State<AchievementBadgesWidget> createState() =>
      _AchievementBadgesWidgetState();
}

class _AchievementBadgesWidgetState extends State<AchievementBadgesWidget>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
    _glowController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.backgroundMid.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryBlue.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Achievement Badges',
            style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          SizedBox(
            height: 20.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.achievements.length,
              itemBuilder: (context, index) {
                final achievement = widget.achievements[index];
                final isUnlocked = achievement['unlocked'] as bool? ?? false;

                return GestureDetector(
                  onTap: () => _showAchievementDetails(context, achievement),
                  child: Container(
                    width: 30.w,
                    margin: EdgeInsets.only(right: 3.w),
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: isUnlocked
                          ? AppTheme.backgroundDeep.withValues(alpha: 0.8)
                          : AppTheme.backgroundDeep.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isUnlocked
                            ? AppTheme.accentGold.withValues(alpha: 0.5)
                            : AppTheme.textSecondary.withValues(alpha: 0.2),
                        width: isUnlocked ? 2 : 1,
                      ),
                      boxShadow: isUnlocked
                          ? [
                              BoxShadow(
                                color:
                                    AppTheme.accentGold.withValues(alpha: 0.3),
                                blurRadius: 12,
                                spreadRadius: 2,
                              ),
                            ]
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedBuilder(
                          animation: _glowAnimation,
                          builder: (context, child) {
                            return Container(
                              padding: EdgeInsets.all(3.w),
                              decoration: BoxDecoration(
                                color: isUnlocked
                                    ? AppTheme.accentGold.withValues(
                                        alpha: _glowAnimation.value * 0.3)
                                    : AppTheme.textSecondary
                                        .withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                                boxShadow: isUnlocked
                                    ? [
                                        BoxShadow(
                                          color: AppTheme.accentGold.withValues(
                                              alpha:
                                                  _glowAnimation.value * 0.5),
                                          blurRadius: 16,
                                          spreadRadius: 2,
                                        ),
                                      ]
                                    : null,
                              ),
                              child: CustomIconWidget(
                                iconName: achievement['icon'] as String? ??
                                    'emoji_events',
                                color: isUnlocked
                                    ? AppTheme.accentGold
                                    : AppTheme.textSecondary,
                                size: 32,
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          achievement['name'] as String? ?? 'Achievement',
                          style:
                              AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                            color: isUnlocked
                                ? AppTheme.textPrimary
                                : AppTheme.textSecondary,
                            fontWeight:
                                isUnlocked ? FontWeight.w600 : FontWeight.w400,
                            fontSize: 10.sp,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (!isUnlocked) ...[
                          SizedBox(height: 1.h),
                          Container(
                            width: double.infinity,
                            height: 0.5.h,
                            decoration: BoxDecoration(
                              color: AppTheme.backgroundDeep,
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor:
                                  (achievement['progress'] as double? ?? 0.0) /
                                      100.0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryBlue,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            '${achievement['progress'] ?? 0}%',
                            style: AppTheme.darkTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.textSecondary,
                              fontSize: 8.sp,
                            ),
                          ),
                        ],
                      ],
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

  void _showAchievementDetails(
      BuildContext context, Map<String, dynamic> achievement) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.backgroundMid,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.textSecondary.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.accentGold.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: achievement['icon'] as String? ?? 'emoji_events',
                color: AppTheme.accentGold,
                size: 48,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              achievement['name'] as String? ?? 'Achievement',
              style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              achievement['description'] as String? ??
                  'Achievement description',
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            if (!(achievement['unlocked'] as bool? ?? false)) ...[
              Text(
                'Requirements:',
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                achievement['requirement'] as String? ??
                    'Complete the challenge',
                style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 2.h),
              Container(
                width: double.infinity,
                height: 1.h,
                decoration: BoxDecoration(
                  color: AppTheme.backgroundDeep,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor:
                      (achievement['progress'] as double? ?? 0.0) / 100.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                'Progress: ${achievement['progress'] ?? 0}%',
                style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
            SizedBox(height: 3.h),
          ],
        ),
      ),
    );
  }
}

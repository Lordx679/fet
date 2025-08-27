import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class StatsGridWidget extends StatefulWidget {
  final Map<String, dynamic> userData;

  const StatsGridWidget({
    Key? key,
    required this.userData,
  }) : super(key: key);

  @override
  State<StatsGridWidget> createState() => _StatsGridWidgetState();
}

class _StatsGridWidgetState extends State<StatsGridWidget>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      4,
      (index) => AnimationController(
        duration: Duration(milliseconds: 1500 + (index * 200)),
        vsync: this,
      ),
    );
    _animations = _controllers
        .map((controller) => Tween<double>(begin: 0, end: 1).animate(
              CurvedAnimation(parent: controller, curve: Curves.easeOutBack),
            ))
        .toList();

    for (var controller in _controllers) {
      controller.forward();
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stats = [
      {
        'title': 'Total XP',
        'value': widget.userData['totalXP']?.toString() ?? '0',
        'icon': 'star',
        'color': AppTheme.accentGold,
      },
      {
        'title': 'Level',
        'value': widget.userData['level']?.toString() ?? '1',
        'icon': 'trending_up',
        'color': AppTheme.primaryBlue,
      },
      {
        'title': 'Workouts',
        'value': widget.userData['workoutsCompleted']?.toString() ?? '0',
        'icon': 'fitness_center',
        'color': AppTheme.secondaryPurple,
      },
      {
        'title': 'Streak',
        'value': '${widget.userData['currentStreak'] ?? 0} days',
        'icon': 'local_fire_department',
        'color': AppTheme.errorRed,
      },
    ];

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
            'Statistics',
            style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 3.w,
              mainAxisSpacing: 2.h,
              childAspectRatio: 1.2,
            ),
            itemCount: stats.length,
            itemBuilder: (context, index) {
              final stat = stats[index];
              return AnimatedBuilder(
                animation: _animations[index],
                builder: (context, child) {
                  return Transform.scale(
                    scale: _animations[index].value,
                    child: Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: AppTheme.backgroundMid,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color:
                              (stat['color'] as Color).withValues(alpha: 0.3),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color:
                                (stat['color'] as Color).withValues(alpha: 0.2),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(2.w),
                            decoration: BoxDecoration(
                              color: (stat['color'] as Color)
                                  .withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: CustomIconWidget(
                              iconName: stat['icon'] as String,
                              color: stat['color'] as Color,
                              size: 24,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            stat['value'] as String,
                            style: AppTheme.dataDisplayMedium.copyWith(
                              color: AppTheme.textPrimary,
                              fontSize: 16.sp,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            stat['title'] as String,
                            style: AppTheme.darkTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.textSecondary,
                              fontSize: 10.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

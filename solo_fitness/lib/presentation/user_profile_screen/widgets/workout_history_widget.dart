import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class WorkoutHistoryWidget extends StatefulWidget {
  final List<Map<String, dynamic>> workoutHistory;

  const WorkoutHistoryWidget({
    Key? key,
    required this.workoutHistory,
  }) : super(key: key);

  @override
  State<WorkoutHistoryWidget> createState() => _WorkoutHistoryWidgetState();
}

class _WorkoutHistoryWidgetState extends State<WorkoutHistoryWidget>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPeriod = 'Weekly';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Workout History',
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.backgroundDeep.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppTheme.primaryBlue.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => _selectedPeriod = 'Weekly'),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: _selectedPeriod == 'Weekly'
                              ? AppTheme.primaryBlue
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Weekly',
                          style:
                              AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                            color: _selectedPeriod == 'Weekly'
                                ? AppTheme.textPrimary
                                : AppTheme.textSecondary,
                            fontSize: 10.sp,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 1.w),
                    GestureDetector(
                      onTap: () => setState(() => _selectedPeriod = 'Monthly'),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: _selectedPeriod == 'Monthly'
                              ? AppTheme.primaryBlue
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Monthly',
                          style:
                              AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                            color: _selectedPeriod == 'Monthly'
                                ? AppTheme.textPrimary
                                : AppTheme.textSecondary,
                            fontSize: 10.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          SizedBox(
            height: 25.h,
            child: ListView.builder(
              itemCount: widget.workoutHistory.length,
              itemBuilder: (context, index) {
                final workout = widget.workoutHistory[index];
                return GestureDetector(
                  onTap: () => _showWorkoutDetails(context, workout),
                  child: Container(
                    margin: EdgeInsets.only(bottom: 2.h),
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundDeep.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.textSecondary.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: _getWorkoutTypeColor(
                                    workout['type'] as String? ?? 'Strength')
                                .withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: CustomIconWidget(
                            iconName: _getWorkoutTypeIcon(
                                workout['type'] as String? ?? 'Strength'),
                            color: _getWorkoutTypeColor(
                                workout['type'] as String? ?? 'Strength'),
                            size: 24,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                workout['name'] as String? ?? 'Workout',
                                style: AppTheme.darkTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color: AppTheme.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 0.5.h),
                              Row(
                                children: [
                                  Text(
                                    '${workout['duration'] ?? 0} min',
                                    style: AppTheme
                                        .darkTheme.textTheme.bodySmall
                                        ?.copyWith(
                                      color: AppTheme.textSecondary,
                                      fontSize: 10.sp,
                                    ),
                                  ),
                                  SizedBox(width: 2.w),
                                  Container(
                                    width: 1,
                                    height: 12,
                                    color: AppTheme.textSecondary
                                        .withValues(alpha: 0.3),
                                  ),
                                  SizedBox(width: 2.w),
                                  Text(
                                    '${workout['calories'] ?? 0} cal',
                                    style: AppTheme
                                        .darkTheme.textTheme.bodySmall
                                        ?.copyWith(
                                      color: AppTheme.textSecondary,
                                      fontSize: 10.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              workout['date'] as String? ?? 'Today',
                              style: AppTheme.darkTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.textSecondary,
                                fontSize: 10.sp,
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 0.5.h),
                              decoration: BoxDecoration(
                                color:
                                    AppTheme.accentGold.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '+${workout['xpEarned'] ?? 0} XP',
                                style: AppTheme.darkTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme.accentGold,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 9.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
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

  Color _getWorkoutTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'strength':
        return AppTheme.primaryBlue;
      case 'cardio':
        return AppTheme.errorRed;
      case 'flexibility':
        return AppTheme.secondaryPurple;
      case 'yoga':
        return AppTheme.successGreen;
      default:
        return AppTheme.primaryBlue;
    }
  }

  String _getWorkoutTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'strength':
        return 'fitness_center';
      case 'cardio':
        return 'directions_run';
      case 'flexibility':
        return 'self_improvement';
      case 'yoga':
        return 'spa';
      default:
        return 'fitness_center';
    }
  }

  void _showWorkoutDetails(BuildContext context, Map<String, dynamic> workout) {
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: _getWorkoutTypeColor(
                            workout['type'] as String? ?? 'Strength')
                        .withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CustomIconWidget(
                    iconName: _getWorkoutTypeIcon(
                        workout['type'] as String? ?? 'Strength'),
                    color: _getWorkoutTypeColor(
                        workout['type'] as String? ?? 'Strength'),
                    size: 32,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        workout['name'] as String? ?? 'Workout',
                        style:
                            AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        workout['type'] as String? ?? 'Strength',
                        style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                    'Duration', '${workout['duration'] ?? 0} min', 'timer'),
                _buildStatItem('Calories', '${workout['calories'] ?? 0}',
                    'local_fire_department'),
                _buildStatItem(
                    'XP Earned', '+${workout['xpEarned'] ?? 0}', 'star'),
              ],
            ),
            SizedBox(height: 3.h),
            Text(
              'Exercises:',
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            ...(workout['exercises'] as List<String>? ??
                    ['Push-ups', 'Squats', 'Planks'])
                .map(
              (exercise) => Padding(
                padding: EdgeInsets.only(bottom: 0.5.h),
                child: Row(
                  children: [
                    Container(
                      width: 1.w,
                      height: 1.w,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlue,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      exercise,
                      style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 3.h),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, String iconName) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: AppTheme.primaryBlue.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomIconWidget(
            iconName: iconName,
            color: AppTheme.primaryBlue,
            size: 20,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          value,
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondary,
            fontSize: 10.sp,
          ),
        ),
      ],
    );
  }
}

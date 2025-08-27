import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SettingsWidget extends StatefulWidget {
  final Map<String, bool> settingsState;
  final Function(String setting, bool value) onSettingChanged;

  const SettingsWidget({
    Key? key,
    required this.settingsState,
    required this.onSettingChanged,
  }) : super(key: key);

  @override
  State<SettingsWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
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
            'Settings',
            style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),
          _buildSettingItem(
            'Push Notifications',
            'Receive workout reminders and achievements',
            'notifications',
            'notifications',
            widget.settingsState['notifications'] ?? true,
          ),
          SizedBox(height: 2.h),
          _buildSettingItem(
            'Workout Reminders',
            'Daily reminders to complete your workouts',
            'alarm',
            'workoutReminders',
            widget.settingsState['workoutReminders'] ?? true,
          ),
          SizedBox(height: 2.h),
          _buildSettingItem(
            'Achievement Alerts',
            'Get notified when you unlock new badges',
            'emoji_events',
            'achievementAlerts',
            widget.settingsState['achievementAlerts'] ?? true,
          ),
          SizedBox(height: 2.h),
          _buildSettingItem(
            'Data Privacy',
            'Share anonymous usage data to improve app',
            'privacy_tip',
            'dataPrivacy',
            widget.settingsState['dataPrivacy'] ?? false,
          ),
          SizedBox(height: 2.h),
          _buildSettingItem(
            'Dark Mode',
            'Use dark theme throughout the app',
            'dark_mode',
            'darkMode',
            widget.settingsState['darkMode'] ?? true,
          ),
          SizedBox(height: 3.h),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildSettingItem(
    String title,
    String description,
    String iconName,
    String settingKey,
    bool currentValue,
  ) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.backgroundDeep.withValues(alpha: 0.3),
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
              color: AppTheme.primaryBlue.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: iconName,
              color: AppTheme.primaryBlue,
              size: 20,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  description,
                  style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                    fontSize: 10.sp,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 2.w),
          GestureDetector(
            onTap: () {
              _animationController.forward().then((_) {
                _animationController.reverse();
              });
              widget.onSettingChanged(settingKey, !currentValue);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 12.w,
              height: 6.w,
              decoration: BoxDecoration(
                color: currentValue
                    ? AppTheme.primaryBlue
                    : AppTheme.textSecondary.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(6.w),
                boxShadow: currentValue
                    ? [
                        BoxShadow(
                          color: AppTheme.primaryBlue.withValues(alpha: 0.3),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ]
                    : null,
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 200),
                alignment:
                    currentValue ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 5.w,
                  height: 5.w,
                  margin: EdgeInsets.all(0.5.w),
                  decoration: BoxDecoration(
                    color: AppTheme.textPrimary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 0.5,
          color: AppTheme.textSecondary.withValues(alpha: 0.2),
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _showDataExportDialog(context),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundDeep.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.successGreen.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'download',
                        color: AppTheme.successGreen,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Export Data',
                        style:
                            AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.successGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: GestureDetector(
                onTap: () => _showAccountDeletionDialog(context),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundDeep.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.errorRed.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'delete_forever',
                        color: AppTheme.errorRed,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Delete Account',
                        style:
                            AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.errorRed,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showDataExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.backgroundMid,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: AppTheme.primaryBlue.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        title: Text(
          'Export Your Data',
          style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Your workout data, achievements, and progress will be exported as a JSON file. This may take a few moments.',
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Simulate data export
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Data exported successfully!'),
                  backgroundColor: AppTheme.successGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.successGreen,
            ),
            child: Text(
              'Export',
              style: TextStyle(color: AppTheme.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  void _showAccountDeletionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.backgroundMid,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: AppTheme.errorRed.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        title: Text(
          'Delete Account',
          style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.errorRed,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'This action cannot be undone. All your workout data, achievements, and progress will be permanently deleted.',
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Simulate account deletion
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'Account deletion initiated. You will be logged out.'),
                  backgroundColor: AppTheme.errorRed,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorRed,
            ),
            child: Text(
              'Delete Forever',
              style: TextStyle(color: AppTheme.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ChatMessageWidget extends StatelessWidget {
  final Map<String, dynamic> message;
  final bool isUser;

  const ChatMessageWidget({
    Key? key,
    required this.message,
    required this.isUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.w),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) _buildCoachAvatar(),
          if (!isUser) SizedBox(width: 3.w),
          Flexible(
            child: _buildMessageBubble(context),
          ),
          if (isUser) SizedBox(width: 3.w),
          if (isUser) _buildUserAvatar(),
        ],
      ),
    );
  }

  Widget _buildCoachAvatar() {
    return Container(
      width: 10.w,
      height: 10.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            AppTheme.secondaryPurple,
            AppTheme.primaryBlue,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.secondaryPurple.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: CustomIconWidget(
        iconName: 'smart_toy',
        color: AppTheme.textPrimary,
        size: 5.w,
      ),
    );
  }

  Widget _buildUserAvatar() {
    return Container(
      width: 10.w,
      height: 10.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryBlue,
            AppTheme.accentGold,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryBlue.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: CustomIconWidget(
        iconName: 'person',
        color: AppTheme.textPrimary,
        size: 5.w,
      ),
    );
  }

  Widget _buildMessageBubble(BuildContext context) {
    return GestureDetector(
      onLongPress: () => _showMessageOptions(context),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 70.w,
          minWidth: 20.w,
        ),
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isUser
                ? [
                    AppTheme.primaryBlue.withValues(alpha: 0.8),
                    AppTheme.primaryBlue.withValues(alpha: 0.6),
                  ]
                : [
                    AppTheme.backgroundMid,
                    AppTheme.backgroundMid.withValues(alpha: 0.8),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(4.w),
            topRight: Radius.circular(4.w),
            bottomLeft: isUser ? Radius.circular(4.w) : Radius.circular(1.w),
            bottomRight: isUser ? Radius.circular(1.w) : Radius.circular(4.w),
          ),
          border: Border.all(
            color: isUser
                ? AppTheme.primaryBlue.withValues(alpha: 0.3)
                : AppTheme.secondaryPurple.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isUser
                  ? AppTheme.primaryBlueGlow
                  : AppTheme.secondaryPurpleGlow,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message['content'] as String,
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textPrimary,
                height: 1.4,
              ),
            ),
            if (message['type'] == 'workout_suggestion') ...[
              SizedBox(height: 2.h),
              _buildWorkoutSuggestion(),
            ],
            if (message['type'] == 'nutrition_advice') ...[
              SizedBox(height: 2.h),
              _buildNutritionAdvice(),
            ],
            SizedBox(height: 1.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  _formatTime(message['timestamp'] as DateTime),
                  style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary.withValues(alpha: 0.7),
                    fontSize: 10.sp,
                  ),
                ),
                if (isUser) ...[
                  SizedBox(width: 2.w),
                  CustomIconWidget(
                    iconName: message['isRead'] == true ? 'done_all' : 'done',
                    color: message['isRead'] == true
                        ? AppTheme.primaryBlue
                        : AppTheme.textSecondary.withValues(alpha: 0.7),
                    size: 3.w,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutSuggestion() {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.backgroundDeep.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(
          color: AppTheme.accentGold.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'fitness_center',
                color: AppTheme.accentGold,
                size: 4.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Recommended Workout',
                style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                  color: AppTheme.accentGold,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            message['workoutName'] as String? ?? 'Push-up Challenge',
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          ElevatedButton(
            onPressed: () {
              // Navigate to workout timer
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentGold,
              foregroundColor: AppTheme.backgroundDeep,
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2.w),
              ),
            ),
            child: Text(
              'Start Workout',
              style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                color: AppTheme.backgroundDeep,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionAdvice() {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.backgroundDeep.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(
          color: AppTheme.successGreen.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'restaurant',
                color: AppTheme.successGreen,
                size: 4.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Nutrition Tip',
                style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                  color: AppTheme.successGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          if (message['mealImage'] != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(2.w),
              child: CustomImageWidget(
                imageUrl: message['mealImage'] as String,
                width: double.infinity,
                height: 15.h,
                fit: BoxFit.cover,
              ),
            ),
        ],
      ),
    );
  }

  void _showMessageOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.backgroundMid,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(4.w)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName: 'copy',
                color: AppTheme.textPrimary,
                size: 5.w,
              ),
              title: Text(
                'Copy',
                style: AppTheme.darkTheme.textTheme.bodyMedium,
              ),
              onTap: () {
                Navigator.pop(context);
                // Copy to clipboard
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: AppTheme.textPrimary,
                size: 5.w,
              ),
              title: Text(
                'Share',
                style: AppTheme.darkTheme.textTheme.bodyMedium,
              ),
              onTap: () {
                Navigator.pop(context);
                // Share message
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'favorite',
                color: AppTheme.textPrimary,
                size: 5.w,
              ),
              title: Text(
                'Save to Favorites',
                style: AppTheme.darkTheme.textTheme.bodyMedium,
              ),
              onTap: () {
                Navigator.pop(context);
                // Save to favorites
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h';
    } else {
      return '${timestamp.day}/${timestamp.month}';
    }
  }
}

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CoachHeaderWidget extends StatefulWidget {
  final int userLevel;
  final String userName;

  const CoachHeaderWidget({
    Key? key,
    required this.userLevel,
    required this.userName,
  }) : super(key: key);

  @override
  State<CoachHeaderWidget> createState() => _CoachHeaderWidgetState();
}

class _CoachHeaderWidgetState extends State<CoachHeaderWidget>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;
  late AnimationController _expressionController;
  late Animation<double> _expressionAnimation;

  @override
  void initState() {
    super.initState();

    _glowController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );

    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    _expressionController = AnimationController(
      duration: Duration(milliseconds: 3000),
      vsync: this,
    );

    _expressionAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _expressionController,
      curve: Curves.easeInOut,
    ));

    _glowController.repeat(reverse: true);
    _expressionController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    _expressionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.backgroundDeep,
            AppTheme.backgroundMid.withValues(alpha: 0.8),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: Border(
          bottom: BorderSide(
            color: AppTheme.primaryBlue.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.backgroundMid,
                  border: Border.all(
                    color: AppTheme.primaryBlue.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: CustomIconWidget(
                  iconName: 'arrow_back',
                  color: AppTheme.textPrimary,
                  size: 5.w,
                ),
              ),
            ),
            SizedBox(width: 4.w),
            _buildCoachAvatar(),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'AI Coach',
                        style:
                            AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.successGreen,
                              AppTheme.accentGold
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(2.w),
                        ),
                        child: Text(
                          'ONLINE',
                          style:
                              AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.backgroundDeep,
                            fontWeight: FontWeight.w600,
                            fontSize: 8.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    'Training ${widget.userName} • Level ${widget.userLevel}',
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  _buildTypingIndicator(),
                ],
              ),
            ),
            _buildMenuButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildCoachAvatar() {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          width: 15.w,
          height: 15.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                AppTheme.secondaryPurple,
                AppTheme.primaryBlue,
                AppTheme.accentGold,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.secondaryPurple
                    .withValues(alpha: _glowAnimation.value),
                blurRadius: 12,
                offset: Offset(0, 0),
              ),
              BoxShadow(
                color: AppTheme.primaryBlue
                    .withValues(alpha: _glowAnimation.value * 0.5),
                blurRadius: 20,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomIconWidget(
                iconName: 'smart_toy',
                color: AppTheme.textPrimary,
                size: 8.w,
              ),
              AnimatedBuilder(
                animation: _expressionAnimation,
                builder: (context, child) {
                  return Positioned(
                    bottom: 2.w,
                    right: 2.w,
                    child: Container(
                      width: 4.w,
                      height: 4.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.successGreen,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.successGreen
                                .withValues(alpha: _expressionAnimation.value),
                            blurRadius: 6,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTypingIndicator() {
    return Row(
      children: [
        Container(
          width: 2.w,
          height: 2.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.successGreen,
          ),
        ),
        SizedBox(width: 1.w),
        Text(
          'Ready to help you achieve your goals',
          style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.successGreen,
            fontSize: 9.sp,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuButton() {
    return GestureDetector(
      onTap: () => _showCoachMenu(context),
      child: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppTheme.backgroundMid,
          border: Border.all(
            color: AppTheme.primaryBlue.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: CustomIconWidget(
          iconName: 'more_vert',
          color: AppTheme.textPrimary,
          size: 5.w,
        ),
      ),
    );
  }

  void _showCoachMenu(BuildContext context) {
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
            Container(
              width: 12.w,
              height: 1.h,
              decoration: BoxDecoration(
                color: AppTheme.textSecondary.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2.w),
              ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'history',
                color: AppTheme.textPrimary,
                size: 5.w,
              ),
              title: Text(
                'Chat History',
                style: AppTheme.darkTheme.textTheme.bodyMedium,
              ),
              onTap: () {
                Navigator.pop(context);
                // Show chat history
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'settings',
                color: AppTheme.textPrimary,
                size: 5.w,
              ),
              title: Text(
                'Coach Settings',
                style: AppTheme.darkTheme.textTheme.bodyMedium,
              ),
              onTap: () {
                Navigator.pop(context);
                // Show coach settings
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'help',
                color: AppTheme.textPrimary,
                size: 5.w,
              ),
              title: Text(
                'Help & Tips',
                style: AppTheme.darkTheme.textTheme.bodyMedium,
              ),
              onTap: () {
                Navigator.pop(context);
                // Show help
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'clear',
                color: AppTheme.errorRed,
                size: 5.w,
              ),
              title: Text(
                'Clear Chat',
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.errorRed,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                // Clear chat history
              },
            ),
          ],
        ),
      ),
    );
  }
}

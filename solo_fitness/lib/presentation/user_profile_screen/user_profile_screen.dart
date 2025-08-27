import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/achievement_badges_widget.dart';
import './widgets/personal_info_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/settings_widget.dart';
import './widgets/stats_grid_widget.dart';
import './widgets/workout_history_widget.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _backgroundController;
  late Animation<double> _backgroundAnimation;

  // Mock user data
  Map<String, dynamic> userData = {
    'name': 'Ahmed Hassan',
    'avatar':
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
    'level': 12,
    'rank': 'Champion',
    'totalXP': 12450,
    'workoutsCompleted': 89,
    'currentStreak': 7,
    'weight': 75,
    'height': 180,
    'age': 28,
    'goal': 'Build Muscle & Strength',
    'activityLevel': 'Very Active',
  };

  // Mock achievements data
  final List<Map<String, dynamic>> achievements = [
    {
      'id': 1,
      'name': 'First Steps',
      'description': 'Complete your first workout session',
      'icon': 'directions_walk',
      'unlocked': true,
      'progress': 100,
      'requirement': 'Complete 1 workout',
    },
    {
      'id': 2,
      'name': 'Consistency King',
      'description': 'Maintain a 7-day workout streak',
      'icon': 'local_fire_department',
      'unlocked': true,
      'progress': 100,
      'requirement': 'Complete 7 consecutive workouts',
    },
    {
      'id': 3,
      'name': 'Strength Master',
      'description': 'Complete 50 strength training sessions',
      'icon': 'fitness_center',
      'unlocked': false,
      'progress': 76,
      'requirement': 'Complete 50 strength workouts',
    },
    {
      'id': 4,
      'name': 'Cardio Champion',
      'description': 'Burn 10,000 calories through cardio',
      'icon': 'favorite',
      'unlocked': false,
      'progress': 45,
      'requirement': 'Burn 10,000 calories in cardio',
    },
    {
      'id': 5,
      'name': 'Level Up Legend',
      'description': 'Reach level 15 in your fitness journey',
      'icon': 'trending_up',
      'unlocked': false,
      'progress': 80,
      'requirement': 'Reach level 15',
    },
  ];

  // Mock workout history
  final List<Map<String, dynamic>> workoutHistory = [
    {
      'id': 1,
      'name': 'Upper Body Strength',
      'type': 'Strength',
      'duration': 45,
      'calories': 320,
      'xpEarned': 150,
      'date': 'Today',
      'exercises': ['Push-ups', 'Pull-ups', 'Bench Press', 'Shoulder Press'],
    },
    {
      'id': 2,
      'name': 'Morning Cardio',
      'type': 'Cardio',
      'duration': 30,
      'calories': 280,
      'xpEarned': 120,
      'date': 'Yesterday',
      'exercises': ['Running', 'Jumping Jacks', 'Burpees', 'Mountain Climbers'],
    },
    {
      'id': 3,
      'name': 'Leg Day Power',
      'type': 'Strength',
      'duration': 50,
      'calories': 380,
      'xpEarned': 180,
      'date': '2 days ago',
      'exercises': ['Squats', 'Deadlifts', 'Lunges', 'Calf Raises'],
    },
    {
      'id': 4,
      'name': 'Yoga Flow',
      'type': 'Flexibility',
      'duration': 35,
      'calories': 150,
      'xpEarned': 100,
      'date': '3 days ago',
      'exercises': ['Sun Salutation', 'Warrior Poses', 'Tree Pose', 'Savasana'],
    },
  ];

  // Settings state
  Map<String, bool> settingsState = {
    'notifications': true,
    'workoutReminders': true,
    'achievementAlerts': true,
    'dataPrivacy': false,
    'darkMode': true,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _backgroundAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _backgroundController, curve: Curves.easeInOut),
    );
    _backgroundController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDeep,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _backgroundAnimation,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.backgroundDeep,
                    AppTheme.backgroundMid.withValues(
                        alpha: 0.3 + (_backgroundAnimation.value * 0.2)),
                    AppTheme.backgroundDeep,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
              child: Column(
                children: [
                  _buildAppBar(),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildProfileContent(),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.backgroundMid.withValues(alpha: 0.5),
        border: Border(
          bottom: BorderSide(
            color: AppTheme.primaryBlue.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: 'arrow_back',
                color: AppTheme.primaryBlue,
                size: 24,
              ),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppTheme.primaryBlue,
              indicatorWeight: 3,
              labelColor: AppTheme.primaryBlue,
              unselectedLabelColor: AppTheme.textSecondary,
              labelStyle: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle:
                  AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w400,
              ),
              tabs: const [
                Tab(text: 'Profile'),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _showProfileMenu(context),
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: 'more_vert',
                color: AppTheme.primaryBlue,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          ProfileHeaderWidget(
            userData: userData,
            onEditPressed: () => _showEditProfileModal(context),
          ),
          SizedBox(height: 3.h),
          StatsGridWidget(userData: userData),
          SizedBox(height: 3.h),
          PersonalInfoWidget(
            userData: userData,
            onFieldUpdate: _updateUserField,
          ),
          SizedBox(height: 3.h),
          AchievementBadgesWidget(achievements: achievements),
          SizedBox(height: 3.h),
          WorkoutHistoryWidget(workoutHistory: workoutHistory),
          SizedBox(height: 3.h),
          SettingsWidget(
            settingsState: settingsState,
            onSettingChanged: _updateSetting,
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  void _updateUserField(String field, String value) {
    setState(() {
      userData[field] = value;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$field updated successfully!'),
        backgroundColor: AppTheme.successGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _updateSetting(String setting, bool value) {
    setState(() {
      settingsState[setting] = value;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            '${setting.replaceAll(RegExp(r'([A-Z])'), ' \$1').toLowerCase()} ${value ? 'enabled' : 'disabled'}'),
        backgroundColor: value ? AppTheme.successGreen : AppTheme.warningOrange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _showEditProfileModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.backgroundMid,
      isScrollControlled: true,
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
            Text(
              'Edit Profile',
              style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Profile editing functionality will be available in the next update. You can currently edit individual fields by long-pressing on them in the Personal Information section.',
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                minimumSize: Size(double.infinity, 6.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Got it',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }

  void _showProfileMenu(BuildContext context) {
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
            _buildMenuOption(
              'Share Profile',
              'Share your fitness achievements',
              'share',
              () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Profile sharing feature coming soon!'),
                    backgroundColor: AppTheme.primaryBlue,
                  ),
                );
              },
            ),
            SizedBox(height: 2.h),
            _buildMenuOption(
              'Sync Data',
              'Synchronize with fitness apps',
              'sync',
              () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Data synchronized successfully!'),
                    backgroundColor: AppTheme.successGreen,
                  ),
                );
              },
            ),
            SizedBox(height: 2.h),
            _buildMenuOption(
              'Help & Support',
              'Get help with your account',
              'help',
              () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/ai-coach-chat-screen');
              },
            ),
            SizedBox(height: 2.h),
            _buildMenuOption(
              'Logout',
              'Sign out of your account',
              'logout',
              () {
                Navigator.pop(context);
                _showLogoutConfirmation(context);
              },
            ),
            SizedBox(height: 3.h),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuOption(
      String title, String subtitle, String iconName, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
                  Text(
                    subtitle,
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                      fontSize: 10.sp,
                    ),
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'chevron_right',
              color: AppTheme.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
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
          'Logout',
          style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to logout? Your progress will be saved.',
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
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/google-login-screen',
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorRed,
            ),
            child: Text(
              'Logout',
              style: TextStyle(color: AppTheme.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}

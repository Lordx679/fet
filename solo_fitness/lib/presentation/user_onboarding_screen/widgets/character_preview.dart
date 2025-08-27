import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CharacterPreview extends StatefulWidget {
  final Map<String, dynamic> userData;

  const CharacterPreview({
    Key? key,
    required this.userData,
  }) : super(key: key);

  @override
  State<CharacterPreview> createState() => _CharacterPreviewState();
}

class _CharacterPreviewState extends State<CharacterPreview>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late AnimationController _floatController;
  late Animation<double> _glowAnimation;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();

    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _floatController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    _floatAnimation = Tween<double>(
      begin: -5.0,
      end: 5.0,
    ).animate(CurvedAnimation(
      parent: _floatController,
      curve: Curves.easeInOut,
    ));

    _glowController.repeat(reverse: true);
    _floatController.repeat(reverse: true);
  }

  String _getCharacterClass() {
    return widget.userData['fitnessLevel'] ?? 'Novice';
  }

  Color _getClassColor() {
    switch (_getCharacterClass()) {
      case 'Novice':
        return AppTheme.successGreen;
      case 'Apprentice':
        return AppTheme.primaryBlue;
      case 'Warrior':
        return AppTheme.accentGold;
      default:
        return AppTheme.primaryBlue;
    }
  }

  String _getClassIcon() {
    switch (_getCharacterClass()) {
      case 'Novice':
        return 'person';
      case 'Apprentice':
        return 'fitness_center';
      case 'Warrior':
        return 'military_tech';
      default:
        return 'person';
    }
  }

  List<String> _getSelectedGoals() {
    return (widget.userData['goals'] as List<String>?) ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.w,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Your Fitness Avatar',
            style: AppTheme.darkTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.primaryBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Ready to begin your epic fitness journey!',
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),

          // Character Avatar
          AnimatedBuilder(
            animation: Listenable.merge([_glowController, _floatController]),
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _floatAnimation.value),
                child: Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        _getClassColor()
                            .withValues(alpha: _glowAnimation.value * 0.3),
                        _getClassColor()
                            .withValues(alpha: _glowAnimation.value * 0.1),
                        Colors.transparent,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _getClassColor()
                            .withValues(alpha: _glowAnimation.value * 0.5),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Container(
                    margin: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.backgroundMid,
                      border: Border.all(
                        color: _getClassColor(),
                        width: 3,
                      ),
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: _getClassIcon(),
                        color: _getClassColor(),
                        size: 15.w,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          SizedBox(height: 3.h),

          // Character Stats
          _buildCharacterStats(),

          SizedBox(height: 3.h),

          // Selected Goals
          if (_getSelectedGoals().isNotEmpty) _buildSelectedGoals(),
        ],
      ),
    );
  }

  Widget _buildCharacterStats() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppTheme.backgroundMid,
        border: Border.all(
          color: _getClassColor().withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: _getClassColor().withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            '${_getCharacterClass()} Adventurer',
            style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
              color: _getClassColor(),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(
                'Age',
                '${widget.userData['age'] ?? 'N/A'}',
                'cake',
              ),
              _buildStatItem(
                'Weight',
                '${widget.userData['weight'] ?? 'N/A'} kg',
                'monitor_weight',
              ),
              _buildStatItem(
                'Height',
                '${widget.userData['height'] ?? 'N/A'} cm',
                'height',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, String icon) {
    return Column(
      children: [
        Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.primaryBlue.withValues(alpha: 0.2),
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: icon,
              color: AppTheme.primaryBlue,
              size: 6.w,
            ),
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          value,
          style: AppTheme.dataDisplaySmall.copyWith(
            fontSize: 12.sp,
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedGoals() {
    final goals = _getSelectedGoals();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppTheme.backgroundMid,
        border: Border.all(
          color: AppTheme.secondaryPurple.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Active Quests',
            style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.secondaryPurple,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: goals.map((goal) => _buildGoalChip(goal)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalChip(String goal) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppTheme.secondaryPurple.withValues(alpha: 0.2),
        border: Border.all(
          color: AppTheme.secondaryPurple.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Text(
        goal.replaceAll('_', ' ').toUpperCase(),
        style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
          color: AppTheme.secondaryPurple,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    _floatController.dispose();
    super.dispose();
  }
}

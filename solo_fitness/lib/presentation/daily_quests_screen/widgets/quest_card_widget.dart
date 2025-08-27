import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../daily_quests_screen.dart';

class QuestCardWidget extends StatefulWidget {
  final Quest quest;
  final VoidCallback onTap;
  final Duration animationDelay;

  const QuestCardWidget({
    super.key,
    required this.quest,
    required this.onTap,
    this.animationDelay = Duration.zero,
  });

  @override
  State<QuestCardWidget> createState() => _QuestCardWidgetState();
}

class _QuestCardWidgetState extends State<QuestCardWidget>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _glowController;
  late AnimationController _progressController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _progressAnimation;

  bool _showRequirements = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _progressController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.3, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.quest.progress,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeOutQuart,
    ));

    // Start animations with delay
    Future.delayed(widget.animationDelay, () {
      if (mounted) {
        _slideController.forward();
        _progressController.forward();
        if (widget.quest.isCompleted) {
          _glowController.repeat(reverse: true);
        }
      }
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _glowController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  Color get _cardBorderColor {
    if (widget.quest.isCompleted) {
      return AppTheme.successGreen;
    }
    switch (widget.quest.difficulty) {
      case QuestDifficulty.bronze:
        return AppTheme.primaryBlue;
      case QuestDifficulty.silver:
        return AppTheme.secondaryPurple;
      case QuestDifficulty.gold:
        return AppTheme.accentGold;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: GestureDetector(
        onTap: widget.onTap,
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            setState(() {
              _showRequirements = !_showRequirements;
            });
          }
        },
        child: AnimatedBuilder(
          animation: widget.quest.isCompleted
              ? _glowAnimation
              : const AlwaysStoppedAnimation(0.5),
          builder: (context, child) {
            return Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.backgroundMid,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _cardBorderColor.withValues(
                    alpha: widget.quest.isCompleted
                        ? _glowAnimation.value * 0.8
                        : 0.3,
                  ),
                  width: widget.quest.isCompleted ? 2 : 1,
                ),
                boxShadow: [
                  if (widget.quest.isCompleted)
                    BoxShadow(
                      color: _cardBorderColor.withValues(
                          alpha: _glowAnimation.value * 0.3),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  BoxShadow(
                    color: AppTheme.shadowBlue,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _showRequirements
                    ? _buildRequirementsView()
                    : _buildMainView(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMainView() {
    return Column(
      key: const ValueKey('main'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row
        Row(
          children: [
            // Quest Icon with glow
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: _cardBorderColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _cardBorderColor.withValues(alpha: 0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _cardBorderColor.withValues(alpha: 0.2),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Icon(
                widget.quest.icon,
                color: _cardBorderColor,
                size: 24.sp,
              ),
            ),
            SizedBox(width: 3.w),
            // Quest Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.quest.title,
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                            letterSpacing: 0.25,
                          ),
                        ),
                      ),
                      // Difficulty Badge
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 2.w,
                          vertical: 0.5.h,
                        ),
                        decoration: BoxDecoration(
                          color: widget.quest.difficulty.color
                              .withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: widget.quest.difficulty.color
                                .withValues(alpha: 0.5),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          widget.quest.difficulty.name,
                          style: GoogleFonts.inter(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                            color: widget.quest.difficulty.color,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    widget.quest.description,
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: AppTheme.textSecondary,
                      letterSpacing: 0.25,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    widget.quest.category,
                    style: GoogleFonts.inter(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.primaryBlue,
                      letterSpacing: 0.25,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 3.h),
        // Progress Section
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Progress',
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textSecondary,
                          letterSpacing: 0.25,
                        ),
                      ),
                      Text(
                        '${(widget.quest.progress * 100).toInt()}%',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  // Animated Progress Bar
                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundDeep.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: AnimatedBuilder(
                      animation: _progressAnimation,
                      builder: (context, child) {
                        return FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: _progressAnimation.value,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  _cardBorderColor,
                                  _cardBorderColor.withValues(alpha: 0.7),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(4),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      _cardBorderColor.withValues(alpha: 0.3),
                                  blurRadius: 4,
                                  spreadRadius: 1,
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
            ),
            SizedBox(width: 4.w),
            // XP Reward
            Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 3.w,
                    vertical: 1.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.accentGold.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.accentGold.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.stars,
                        color: AppTheme.accentGold,
                        size: 16.sp,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        '${widget.quest.xpReward}',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.accentGold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'XP',
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 3.h),
        // Action Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: widget.onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.quest.isCompleted
                  ? AppTheme.successGreen
                  : _cardBorderColor,
              foregroundColor: AppTheme.textPrimary,
              padding: EdgeInsets.symmetric(vertical: 1.5.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.quest.isCompleted ? Icons.redeem : Icons.play_arrow,
                  size: 18.sp,
                ),
                SizedBox(width: 2.w),
                Text(
                  widget.quest.isCompleted ? 'Claim Reward' : 'Start Quest',
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRequirementsView() {
    return Column(
      key: const ValueKey('requirements'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  _showRequirements = false;
                });
              },
              icon: const Icon(Icons.arrow_back_ios),
              color: AppTheme.textSecondary,
            ),
            Text(
              'Quest Requirements',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
                letterSpacing: 0.25,
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        // Requirements List
        ...widget.quest.requirements.asMap().entries.map(
          (entry) {
            int index = entry.key;
            String requirement = entry.value;
            bool isCompleted = index <
                (widget.quest.progress * widget.quest.requirements.length)
                    .floor();

            return Padding(
              padding: EdgeInsets.only(bottom: 1.h),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? AppTheme.successGreen
                          : Colors.transparent,
                      border: Border.all(
                        color: isCompleted
                            ? AppTheme.successGreen
                            : AppTheme.textSecondary.withValues(alpha: 0.5),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: isCompleted
                        ? const Icon(
                            Icons.check,
                            size: 14,
                            color: AppTheme.textPrimary,
                          )
                        : null,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      requirement,
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: isCompleted
                            ? AppTheme.textPrimary
                            : AppTheme.textSecondary,
                        letterSpacing: 0.25,
                        decoration:
                            isCompleted ? TextDecoration.lineThrough : null,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ).toList(),
        SizedBox(height: 2.h),
        // Bonus Objectives (placeholder)
        if (widget.quest.difficulty == QuestDifficulty.gold)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bonus Objectives',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.accentGold,
                  letterSpacing: 0.25,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                'Complete within 1 hour for +50 XP bonus',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: AppTheme.textSecondary,
                  letterSpacing: 0.25,
                ),
              ),
            ],
          ),
      ],
    );
  }
}

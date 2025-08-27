import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FloatingTimerWidget extends StatefulWidget {
  final int remainingSeconds;
  final bool isActive;
  final bool isResting;
  final String exerciseName;
  final VoidCallback onTap;
  final VoidCallback onClose;

  const FloatingTimerWidget({
    Key? key,
    required this.remainingSeconds,
    required this.isActive,
    required this.isResting,
    required this.exerciseName,
    required this.onTap,
    required this.onClose,
  }) : super(key: key);

  @override
  State<FloatingTimerWidget> createState() => _FloatingTimerWidgetState();
}

class _FloatingTimerWidgetState extends State<FloatingTimerWidget>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _slideController.forward();

    if (widget.isActive) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(FloatingTimerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _pulseController.repeat(reverse: true);
    } else if (!widget.isActive && oldWidget.isActive) {
      _pulseController.stop();
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: widget.isActive ? _pulseAnimation.value : 1.0,
            child: GestureDetector(
              onTap: widget.onTap,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppTheme.backgroundMid,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: widget.isResting
                        ? AppTheme.secondaryPurple.withValues(alpha: 0.5)
                        : AppTheme.primaryBlue.withValues(alpha: 0.5),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.isResting
                          ? AppTheme.shadowPurple
                          : AppTheme.shadowBlue,
                      blurRadius: 12,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Timer circle
                    Container(
                      width: 12.w,
                      height: 12.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.isResting
                            ? AppTheme.secondaryPurple.withValues(alpha: 0.2)
                            : AppTheme.primaryBlue.withValues(alpha: 0.2),
                        border: Border.all(
                          color: widget.isResting
                              ? AppTheme.secondaryPurple
                              : AppTheme.primaryBlue,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          _formatTime(widget.remainingSeconds),
                          style:
                              AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                            color: widget.isResting
                                ? AppTheme.secondaryPurple
                                : AppTheme.primaryBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 3.w),

                    // Exercise info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.exerciseName,
                            style: AppTheme.darkTheme.textTheme.titleSmall
                                ?.copyWith(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            widget.isResting ? 'Rest Period' : 'Active Set',
                            style: AppTheme.darkTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: widget.isResting
                                  ? AppTheme.secondaryPurple
                                  : AppTheme.primaryBlue,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Close button
                    GestureDetector(
                      onTap: widget.onClose,
                      child: Container(
                        width: 8.w,
                        height: 8.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.errorRed.withValues(alpha: 0.2),
                          border: Border.all(
                            color: AppTheme.errorRed.withValues(alpha: 0.5),
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: CustomIconWidget(
                            iconName: 'close',
                            color: AppTheme.errorRed,
                            size: 4.w,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

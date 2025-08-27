import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class TimerDisplayWidget extends StatefulWidget {
  final int totalSeconds;
  final int remainingSeconds;
  final bool isActive;
  final bool isResting;
  final VoidCallback? onTimerComplete;

  const TimerDisplayWidget({
    Key? key,
    required this.totalSeconds,
    required this.remainingSeconds,
    required this.isActive,
    this.isResting = false,
    this.onTimerComplete,
  }) : super(key: key);

  @override
  State<TimerDisplayWidget> createState() => _TimerDisplayWidgetState();
}

class _TimerDisplayWidgetState extends State<TimerDisplayWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _progressController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeOut,
    ));

    if (widget.isActive) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(TimerDisplayWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _pulseController.repeat(reverse: true);
    } else if (!widget.isActive && oldWidget.isActive) {
      _pulseController.stop();
    }

    if (widget.totalSeconds != oldWidget.totalSeconds ||
        widget.remainingSeconds != oldWidget.remainingSeconds) {
      _updateProgress();
    }
  }

  void _updateProgress() {
    final progress = widget.totalSeconds > 0
        ? (widget.totalSeconds - widget.remainingSeconds) / widget.totalSeconds
        : 0.0;
    _progressController.animateTo(progress);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final progress = widget.totalSeconds > 0
        ? (widget.totalSeconds - widget.remainingSeconds) / widget.totalSeconds
        : 0.0;

    return Container(
      width: 70.w,
      height: 70.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          Container(
            width: 70.w,
            height: 70.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.backgroundMid,
              border: Border.all(
                color: AppTheme.textSecondary.withValues(alpha: 0.2),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.shadowBlue,
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),

          // Progress ring
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return CustomPaint(
                size: Size(70.w, 70.w),
                painter: TimerProgressPainter(
                  progress: progress,
                  isResting: widget.isResting,
                  isActive: widget.isActive,
                ),
              );
            },
          ),

          // Pulse effect
          if (widget.isActive)
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    width: 65.w,
                    height: 65.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: widget.isResting
                            ? AppTheme.secondaryPurple.withValues(alpha: 0.3)
                            : AppTheme.primaryBlue.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                  ),
                );
              },
            ),

          // Timer text
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _formatTime(widget.remainingSeconds),
                style: AppTheme.timerDisplay.copyWith(
                  color: widget.isResting
                      ? AppTheme.secondaryPurple
                      : AppTheme.primaryBlue,
                  fontSize: 24.sp,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                widget.isResting ? 'REST' : 'WORK',
                style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                  color: widget.isResting
                      ? AppTheme.secondaryPurple
                      : AppTheme.primaryBlue,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TimerProgressPainter extends CustomPainter {
  final double progress;
  final bool isResting;
  final bool isActive;

  TimerProgressPainter({
    required this.progress,
    required this.isResting,
    required this.isActive,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    // Background track
    final backgroundPaint = Paint()
      ..color = AppTheme.backgroundMid
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress arc
    if (progress > 0) {
      final progressPaint = Paint()
        ..shader = LinearGradient(
          colors: isResting
              ? [AppTheme.secondaryPurple, AppTheme.accentGold]
              : [AppTheme.primaryBlue, AppTheme.secondaryPurple],
        ).createShader(Rect.fromCircle(center: center, radius: radius))
        ..strokeWidth = 8
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      final sweepAngle = 2 * 3.14159 * progress;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -3.14159 / 2, // Start from top
        sweepAngle,
        false,
        progressPaint,
      );

      // Glow effect
      if (isActive) {
        final glowPaint = Paint()
          ..color = isResting
              ? AppTheme.secondaryPurpleGlow
              : AppTheme.primaryBlueGlow
          ..strokeWidth = 12
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          -3.14159 / 2,
          sweepAngle,
          false,
          glowPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

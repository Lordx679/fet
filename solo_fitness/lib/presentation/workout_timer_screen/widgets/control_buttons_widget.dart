import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ControlButtonsWidget extends StatefulWidget {
  final bool isPlaying;
  final bool canGoNext;
  final bool canGoPrevious;
  final VoidCallback onPlayPause;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;
  final VoidCallback? onReset;

  const ControlButtonsWidget({
    Key? key,
    required this.isPlaying,
    required this.canGoNext,
    required this.canGoPrevious,
    required this.onPlayPause,
    this.onNext,
    this.onPrevious,
    this.onReset,
  }) : super(key: key);

  @override
  State<ControlButtonsWidget> createState() => _ControlButtonsWidgetState();
}

class _ControlButtonsWidgetState extends State<ControlButtonsWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    if (widget.isPlaying) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(ControlButtonsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying && !oldWidget.isPlaying) {
      _pulseController.repeat(reverse: true);
    } else if (!widget.isPlaying && oldWidget.isPlaying) {
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
      child: Column(
        children: [
          // Main play/pause button
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: widget.isPlaying ? _pulseAnimation.value : 1.0,
                child: GestureDetector(
                  onTap: widget.onPlayPause,
                  child: Container(
                    width: 20.w,
                    height: 20.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primaryBlue,
                          AppTheme.secondaryPurple,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryBlueGlow,
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                        BoxShadow(
                          color: AppTheme.shadowBlue,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: widget.isPlaying ? 'pause' : 'play_arrow',
                        color: AppTheme.textPrimary,
                        size: 8.w,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          SizedBox(height: 4.h),

          // Navigation and control buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Previous button
              _buildControlButton(
                iconName: 'skip_previous',
                onTap: widget.canGoPrevious ? widget.onPrevious : null,
                isEnabled: widget.canGoPrevious,
              ),

              // Reset button
              _buildControlButton(
                iconName: 'refresh',
                onTap: widget.onReset,
                isEnabled: true,
                color: AppTheme.warningOrange,
              ),

              // Next button
              _buildControlButton(
                iconName: 'skip_next',
                onTap: widget.canGoNext ? widget.onNext : null,
                isEnabled: widget.canGoNext,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required String iconName,
    required VoidCallback? onTap,
    required bool isEnabled,
    Color? color,
  }) {
    final buttonColor = color ?? AppTheme.primaryBlue;

    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Container(
        width: 14.w,
        height: 14.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isEnabled
              ? buttonColor.withValues(alpha: 0.2)
              : AppTheme.backgroundMid,
          border: Border.all(
            color: isEnabled
                ? buttonColor
                : AppTheme.textSecondary.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: buttonColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: CustomIconWidget(
            iconName: iconName,
            color: isEnabled
                ? buttonColor
                : AppTheme.textSecondary.withValues(alpha: 0.5),
            size: 6.w,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class LoadingOverlayWidget extends StatefulWidget {
  final bool isVisible;
  final String message;

  const LoadingOverlayWidget({
    super.key,
    required this.isVisible,
    this.message = 'Initializing Quest...',
  });

  @override
  State<LoadingOverlayWidget> createState() => _LoadingOverlayWidgetState();
}

class _LoadingOverlayWidgetState extends State<LoadingOverlayWidget>
    with TickerProviderStateMixin {
  late AnimationController _spinController;
  late AnimationController _pulseController;
  late Animation<double> _spinAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _spinController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _spinAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _spinController, curve: Curves.linear),
    );

    _pulseAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    if (widget.isVisible) {
      _startAnimations();
    }
  }

  void _startAnimations() {
    _spinController.repeat();
    _pulseController.repeat(reverse: true);
  }

  void _stopAnimations() {
    _spinController.stop();
    _pulseController.stop();
  }

  @override
  void didUpdateWidget(LoadingOverlayWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible && !oldWidget.isVisible) {
      _startAnimations();
    } else if (!widget.isVisible && oldWidget.isVisible) {
      _stopAnimations();
    }
  }

  @override
  void dispose() {
    _spinController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.isVisible
        ? Container(
            width: 100.w,
            height: 100.h,
            color: AppTheme.backgroundDeep.withValues(alpha: 0.9),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation:
                        Listenable.merge([_spinController, _pulseController]),
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: Transform.rotate(
                          angle: _spinAnimation.value * 2 * 3.14159,
                          child: Container(
                            width: 15.w,
                            height: 15.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: SweepGradient(
                                colors: [
                                  AppTheme.primaryBlue,
                                  AppTheme.secondaryPurple,
                                  AppTheme.accentGold,
                                  AppTheme.primaryBlue,
                                ],
                                stops: const [0.0, 0.33, 0.66, 1.0],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.primaryBlue
                                      .withValues(alpha: 0.5),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Container(
                                width: 12.w,
                                height: 12.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppTheme.backgroundDeep,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    widget.message,
                    style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.textPrimary,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 1.h),
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _pulseAnimation.value,
                        child: Text(
                          'Please wait...',
                          style:
                              AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textSecondary,
                            letterSpacing: 0.3,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}

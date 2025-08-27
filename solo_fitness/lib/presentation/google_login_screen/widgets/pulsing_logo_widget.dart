import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class PulsingLogoWidget extends StatefulWidget {
  const PulsingLogoWidget({super.key});

  @override
  State<PulsingLogoWidget> createState() => _PulsingLogoWidgetState();
}

class _PulsingLogoWidgetState extends State<PulsingLogoWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _initializePulseAnimation();
  }

  void _initializePulseAnimation() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _glowAnimation = Tween<double>(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            width: 25.w,
            height: 25.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppTheme.primaryBlue.withValues(alpha: _glowAnimation.value),
                  AppTheme.secondaryPurple
                      .withValues(alpha: _glowAnimation.value * 0.7),
                  AppTheme.accentGold
                      .withValues(alpha: _glowAnimation.value * 0.5),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.3, 0.6, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryBlue
                      .withValues(alpha: _glowAnimation.value),
                  blurRadius: 30,
                  spreadRadius: 10,
                ),
                BoxShadow(
                  color: AppTheme.secondaryPurple
                      .withValues(alpha: _glowAnimation.value * 0.5),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Center(
              child: Container(
                width: 18.w,
                height: 18.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.backgroundMid,
                  border: Border.all(
                    color: AppTheme.primaryBlue.withValues(alpha: 0.8),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    'SF',
                    style: AppTheme.darkTheme.textTheme.headlineSmall?.copyWith(
                      color: AppTheme.primaryBlue,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

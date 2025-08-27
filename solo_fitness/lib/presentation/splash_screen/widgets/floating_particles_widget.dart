import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class FloatingParticlesWidget extends StatefulWidget {
  const FloatingParticlesWidget({super.key});

  @override
  State<FloatingParticlesWidget> createState() =>
      _FloatingParticlesWidgetState();
}

class _FloatingParticlesWidgetState extends State<FloatingParticlesWidget>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<Offset>> _animations;
  late List<Animation<double>> _opacityAnimations;
  final int particleCount = 15;

  @override
  void initState() {
    super.initState();
    _controllers = [];
    _animations = [];
    _opacityAnimations = [];

    for (int i = 0; i < particleCount; i++) {
      final controller = AnimationController(
        duration: Duration(seconds: 3 + math.Random().nextInt(4)),
        vsync: this,
      );

      final animation = Tween<Offset>(
        begin: Offset(
          math.Random().nextDouble() * 2 - 1,
          1.5,
        ),
        end: Offset(
          math.Random().nextDouble() * 2 - 1,
          -1.5,
        ),
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.linear,
      ));

      final opacityAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.3),
      ));

      _controllers.add(controller);
      _animations.add(animation);
      _opacityAnimations.add(opacityAnimation);

      controller.repeat();

      // Stagger the start times
      Future.delayed(Duration(milliseconds: i * 200), () {
        if (mounted) {
          controller.forward();
        }
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.w,
      height: 100.h,
      child: Stack(
        children: List.generate(particleCount, (index) {
          final colors = [
            AppTheme.primaryBlue,
            AppTheme.secondaryPurple,
            AppTheme.accentGold,
          ];
          final color = colors[index % colors.length];

          return AnimatedBuilder(
            animation: _controllers[index],
            builder: (context, child) {
              return Positioned(
                left: (50.w + _animations[index].value.dx * 30.w),
                top: (50.h + _animations[index].value.dy * 40.h),
                child: Opacity(
                  opacity: _opacityAnimations[index].value * 0.7,
                  child: Container(
                    width: 1.w + math.Random().nextDouble() * 2.w,
                    height: 1.w + math.Random().nextDouble() * 2.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color,
                      boxShadow: [
                        BoxShadow(
                          color: color.withValues(alpha: 0.5),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}

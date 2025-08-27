import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class AnimatedParticlesWidget extends StatefulWidget {
  const AnimatedParticlesWidget({super.key});

  @override
  State<AnimatedParticlesWidget> createState() =>
      _AnimatedParticlesWidgetState();
}

class _AnimatedParticlesWidgetState extends State<AnimatedParticlesWidget>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;
  late List<Animation<Offset>> _positionAnimations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _controllers = List.generate(8, (index) {
      return AnimationController(
        duration: Duration(milliseconds: 3000 + (index * 500)),
        vsync: this,
      );
    });

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();

    _positionAnimations = _controllers.asMap().entries.map((entry) {
      int index = entry.key;
      AnimationController controller = entry.value;

      return Tween<Offset>(
        begin: Offset(
          (index % 4) * 25.w,
          (index ~/ 4) * 40.h,
        ),
        end: Offset(
          ((index + 2) % 4) * 25.w,
          ((index + 1) ~/ 4) * 40.h,
        ),
      ).animate(CurvedAnimation(parent: controller, curve: Curves.linear));
    }).toList();

    for (var controller in _controllers) {
      controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
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
        children: List.generate(8, (index) {
          return AnimatedBuilder(
            animation: _controllers[index],
            builder: (context, child) {
              return Positioned(
                left: _positionAnimations[index].value.dx,
                top: _positionAnimations[index].value.dy,
                child: Opacity(
                  opacity: _animations[index].value * 0.6,
                  child: Container(
                    width: 2.w,
                    height: 2.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index % 3 == 0
                          ? AppTheme.primaryBlue
                          : index % 3 == 1
                              ? AppTheme.secondaryPurple
                              : AppTheme.accentGold,
                      boxShadow: [
                        BoxShadow(
                          color: (index % 3 == 0
                                  ? AppTheme.primaryBlue
                                  : index % 3 == 1
                                      ? AppTheme.secondaryPurple
                                      : AppTheme.accentGold)
                              .withValues(alpha: 0.5),
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

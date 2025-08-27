import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class AnimatedBackground extends StatefulWidget {
  final Widget child;

  const AnimatedBackground({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with TickerProviderStateMixin {
  late AnimationController _particleController;
  late AnimationController _gradientController;
  late Animation<double> _gradientAnimation;

  final List<Particle> _particles = [];
  final int _particleCount = 15;

  @override
  void initState() {
    super.initState();

    _particleController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );

    _gradientController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );

    _gradientAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _gradientController,
      curve: Curves.easeInOut,
    ));

    _initializeParticles();
    _particleController.repeat();
    _gradientController.repeat(reverse: true);
  }

  void _initializeParticles() {
    final random = math.Random();
    for (int i = 0; i < _particleCount; i++) {
      _particles.add(Particle(
        x: random.nextDouble() * 100.w,
        y: random.nextDouble() * 100.h,
        size: random.nextDouble() * 4 + 2,
        speed: random.nextDouble() * 0.5 + 0.2,
        color: _getRandomParticleColor(random),
        opacity: random.nextDouble() * 0.6 + 0.2,
      ));
    }
  }

  Color _getRandomParticleColor(math.Random random) {
    final colors = [
      AppTheme.primaryBlue,
      AppTheme.secondaryPurple,
      AppTheme.accentGold,
    ];
    return colors[random.nextInt(colors.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          // Animated gradient background
          AnimatedBuilder(
            animation: _gradientAnimation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.backgroundDeep,
                      AppTheme.backgroundMid.withValues(
                        alpha: 0.8 + (_gradientAnimation.value * 0.2),
                      ),
                      AppTheme.backgroundDeep,
                    ],
                    stops: [
                      0.0,
                      0.3 + (_gradientAnimation.value * 0.4),
                      1.0,
                    ],
                  ),
                ),
              );
            },
          ),

          // Animated particles
          AnimatedBuilder(
            animation: _particleController,
            builder: (context, child) {
              return CustomPaint(
                painter: ParticlePainter(
                  particles: _particles,
                  animationValue: _particleController.value,
                ),
                size: Size(100.w, 100.h),
              );
            },
          ),

          // Content
          widget.child,
        ],
      ),
    );
  }

  @override
  void dispose() {
    _particleController.dispose();
    _gradientController.dispose();
    super.dispose();
  }
}

class Particle {
  double x;
  double y;
  final double size;
  final double speed;
  final Color color;
  final double opacity;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.color,
    required this.opacity,
  });
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animationValue;

  ParticlePainter({
    required this.particles,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      // Update particle position
      particle.y -= particle.speed;
      if (particle.y < -10) {
        particle.y = size.height + 10;
        particle.x = math.Random().nextDouble() * size.width;
      }

      // Create paint with glow effect
      final paint = Paint()
        ..color = particle.color.withValues(alpha: particle.opacity)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, particle.size * 0.5);

      // Draw particle
      canvas.drawCircle(
        Offset(particle.x, particle.y),
        particle.size,
        paint,
      );

      // Draw glow effect
      final glowPaint = Paint()
        ..color = particle.color.withValues(alpha: particle.opacity * 0.3)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, particle.size * 2);

      canvas.drawCircle(
        Offset(particle.x, particle.y),
        particle.size * 2,
        glowPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

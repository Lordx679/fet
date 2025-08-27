import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../theme/app_theme.dart';

class FloatingParticlesWidget extends StatefulWidget {
  final AnimationController controller;

  const FloatingParticlesWidget({
    super.key,
    required this.controller,
  });

  @override
  State<FloatingParticlesWidget> createState() =>
      _FloatingParticlesWidgetState();
}

class _FloatingParticlesWidgetState extends State<FloatingParticlesWidget> {
  late List<Particle> particles;
  final int particleCount = 15;

  @override
  void initState() {
    super.initState();
    _initializeParticles();
  }

  void _initializeParticles() {
    particles = List.generate(particleCount, (index) {
      return Particle(
        startX: math.Random().nextDouble(),
        startY: math.Random().nextDouble(),
        speed: 0.1 + math.Random().nextDouble() * 0.3,
        size: 1.0 + math.Random().nextDouble() * 3.0,
        color: _getRandomParticleColor(),
        opacity: 0.3 + math.Random().nextDouble() * 0.4,
        phase: math.Random().nextDouble() * 2 * math.pi,
        amplitude: 0.1 + math.Random().nextDouble() * 0.2,
      );
    });
  }

  Color _getRandomParticleColor() {
    final colors = [
      AppTheme.primaryBlue,
      AppTheme.secondaryPurple,
      AppTheme.accentGold,
      AppTheme.successGreen,
    ];
    return colors[math.Random().nextInt(colors.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: widget.controller,
        builder: (context, child) {
          return CustomPaint(
            painter: ParticlesPainter(
              particles: particles,
              animationValue: widget.controller.value,
              screenSize: MediaQuery.of(context).size,
            ),
          );
        },
      ),
    );
  }
}

class Particle {
  final double startX;
  final double startY;
  final double speed;
  final double size;
  final Color color;
  final double opacity;
  final double phase;
  final double amplitude;

  Particle({
    required this.startX,
    required this.startY,
    required this.speed,
    required this.size,
    required this.color,
    required this.opacity,
    required this.phase,
    required this.amplitude,
  });
}

class ParticlesPainter extends CustomPainter {
  final List<Particle> particles;
  final double animationValue;
  final Size screenSize;

  ParticlesPainter({
    required this.particles,
    required this.animationValue,
    required this.screenSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final paint = Paint()
        ..color = particle.color.withValues(alpha: particle.opacity)
        ..style = PaintingStyle.fill;

      // Calculate particle position with floating motion
      final progress = (animationValue * particle.speed) % 1.0;
      final x = particle.startX * size.width +
          particle.amplitude *
              size.width *
              math.sin(progress * 2 * math.pi + particle.phase);
      final y = (particle.startY + progress) * size.height % size.height;

      // Draw particle with glow effect
      final glowPaint = Paint()
        ..color = particle.color.withValues(alpha: particle.opacity * 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0);

      // Draw glow
      canvas.drawCircle(
        Offset(x, y),
        particle.size + 2,
        glowPaint,
      );

      // Draw particle
      canvas.drawCircle(
        Offset(x, y),
        particle.size,
        paint,
      );

      // Add sparkle effect for some particles
      if (particle.size > 2.5) {
        final sparklePaint = Paint()
          ..color = AppTheme.textPrimary.withValues(alpha: 0.8)
          ..strokeWidth = 0.5;

        final sparkleSize = particle.size * 0.5;
        canvas.drawLine(
          Offset(x - sparkleSize, y),
          Offset(x + sparkleSize, y),
          sparklePaint,
        );
        canvas.drawLine(
          Offset(x, y - sparkleSize),
          Offset(x, y + sparkleSize),
          sparklePaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(ParticlesPainter oldDelegate) {
    return animationValue != oldDelegate.animationValue;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class GoogleLoginButtonWidget extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const GoogleLoginButtonWidget({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  State<GoogleLoginButtonWidget> createState() =>
      _GoogleLoginButtonWidgetState();
}

class _GoogleLoginButtonWidgetState extends State<GoogleLoginButtonWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _initializeGlowAnimation();
  }

  void _initializeGlowAnimation() {
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _glowAnimation = Tween<double>(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _glowController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    HapticFeedback.lightImpact();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        return GestureDetector(
          onTapDown: widget.isLoading ? null : _handleTapDown,
          onTapUp: widget.isLoading ? null : _handleTapUp,
          onTapCancel: widget.isLoading ? null : _handleTapCancel,
          onTap: widget.isLoading ? null : widget.onPressed,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 85.w,
            height: 7.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryBlue
                      .withValues(alpha: _isPressed ? 0.9 : 0.8),
                  AppTheme.primaryBlue
                      .withValues(alpha: _isPressed ? 0.7 : 0.6),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: AppTheme.primaryBlue
                    .withValues(alpha: _glowAnimation.value),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryBlue
                      .withValues(alpha: _glowAnimation.value * 0.5),
                  blurRadius: _isPressed ? 15 : 20,
                  spreadRadius: _isPressed ? 2 : 5,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: AppTheme.primaryBlueGlow,
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: widget.isLoading
                ? Center(
                    child: SizedBox(
                      width: 6.w,
                      height: 6.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppTheme.textPrimary),
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomImageWidget(
                        imageUrl:
                            "https://developers.google.com/identity/images/g-logo.png",
                        width: 6.w,
                        height: 6.w,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        'Sign in with Google',
                        style:
                            AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}

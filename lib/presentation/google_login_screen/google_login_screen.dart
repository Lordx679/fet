@@ .. @@
 import 'package:flutter/material.dart';
 import 'package:flutter/services.dart';
-import 'package:fluttertoast/fluttertoast.dart';
 import 'package:sizer/sizer.dart';
 
 import '../../core/app_export.dart';
 import '../../theme/app_theme.dart';
 import './widgets/animated_particles_widget.dart';
-import './widgets/google_login_button_widget.dart';
 import './widgets/guest_login_button_widget.dart';
 import './widgets/loading_overlay_widget.dart';
 import './widgets/pulsing_logo_widget.dart';
 
 class GoogleLoginScreen extends StatefulWidget {
   const GoogleLoginScreen({super.key});
 
   @override
   State<GoogleLoginScreen> createState() => _GoogleLoginScreenState();
 }
 
 class _GoogleLoginScreenState extends State<GoogleLoginScreen>
     with TickerProviderStateMixin {
   bool _isLoading = false;
-  bool _showParticleEffect = false;
   late AnimationController _slideController;
   late Animation<Offset> _slideAnimation;
 
-  // Mock credentials for testing
-  final Map<String, dynamic> _mockCredentials = {
-    'admin': {
-      'email': 'admin@solofitness.com',
-      'password': 'admin123',
-      'role': 'Administrator'
-    },
-    'user': {
-      'email': 'user@solofitness.com',
-      'password': 'user123',
-      'role': 'Regular User'
-    },
-    'trainer': {
-      'email': 'trainer@solofitness.com',
-      'password': 'trainer123',
-      'role': 'Fitness Trainer'
-    }
-  };
-
   @override
   void initState() {
     super.initState();
     _initializeAnimations();
-    _checkAuthenticationState();
   }
 
   void _initializeAnimations() {
     _slideController = AnimationController(
       duration: const Duration(milliseconds: 800),
       vsync: this,
     );
 
     _slideAnimation = Tween<Offset>(
       begin: const Offset(0, 1),
       end: Offset.zero,
     ).animate(CurvedAnimation(
       parent: _slideController,
       curve: Curves.easeOutCubic,
     ));
 
     _slideController.forward();
   }
 
-  Future<void> _checkAuthenticationState() async {
-    // Simulate checking stored authentication
-    await Future.delayed(const Duration(milliseconds: 500));
-
-    // Check if user is already authenticated (mock implementation)
-    final bool isAuthenticated = false; // Replace with actual auth check
-
-    if (isAuthenticated && mounted) {
-      _navigateToNextScreen(isGuest: false);
-    }
-  }
-
-  Future<void> _handleGoogleSignIn() async {
-    if (_isLoading) return;
-
-    setState(() => _isLoading = true);
-    HapticFeedback.mediumImpact();
-
-    try {
-      // Simulate Google OAuth flow
-      await Future.delayed(const Duration(milliseconds: 2000));
-
-      // Mock successful authentication
-      final bool authSuccess = true; // Replace with actual Google Sign-In logic
-
-      if (authSuccess) {
-        setState(() => _showParticleEffect = true);
-        HapticFeedback.heavyImpact();
-
-        await Future.delayed(const Duration(milliseconds: 1000));
-
-        if (mounted) {
-          _showSuccessToast('Quest Login Successful! Welcome, Warrior!');
-          _navigateToNextScreen(isGuest: false);
-        }
-      } else {
-        _showErrorToast('Quest Login Failed - Please try again');
-      }
-    } catch (error) {
-      _showErrorToast('Network Connection Lost - Check your connection');
-    } finally {
-      if (mounted) {
-        setState(() {
-          _isLoading = false;
-          _showParticleEffect = false;
-        });
-      }
-    }
-  }
-
-  Future<void> _handleGuestContinue() async {
+  Future<void> _handleContinue() async {
     HapticFeedback.selectionClick();
 
     setState(() => _isLoading = true);
 
-    // Simulate guest session setup
+    // Simulate session setup
     await Future.delayed(const Duration(milliseconds: 1000));
 
     if (mounted) {
-      _showSuccessToast('Guest Mode Activated - Limited Features Available');
-      _navigateToNextScreen(isGuest: true);
+      _navigateToNextScreen();
     }
   }
 
-  void _navigateToNextScreen({required bool isGuest}) {
-    // Navigate to onboarding for new users or dashboard for returning users
+  void _navigateToNextScreen() {
+    // Navigate to onboarding for new users
     Navigator.pushReplacementNamed(context, '/user-onboarding-screen');
   }
 
-  void _showSuccessToast(String message) {
-    Fluttertoast.showToast(
-      msg: message,
-      toastLength: Toast.LENGTH_LONG,
-      gravity: ToastGravity.BOTTOM,
-      backgroundColor: AppTheme.successGreen.withValues(alpha: 0.9),
-      textColor: AppTheme.textPrimary,
-      fontSize: 14.sp,
-    );
-  }
-
-  void _showErrorToast(String message) {
-    Fluttertoast.showToast(
-      msg: message,
-      toastLength: Toast.LENGTH_LONG,
-      gravity: ToastGravity.BOTTOM,
-      backgroundColor: AppTheme.errorRed.withValues(alpha: 0.9),
-      textColor: AppTheme.textPrimary,
-      fontSize: 14.sp,
-    );
-  }
-
   Future<bool> _onWillPop() async {
     // Exit app if accessed from splash
     SystemNavigator.pop();
     return false;
   }
 
   @override
   void dispose() {
     _slideController.dispose();
     super.dispose();
   }
 
   @override
   Widget build(BuildContext context) {
     return WillPopScope(
       onWillPop: _onWillPop,
       child: Scaffold(
         backgroundColor: AppTheme.backgroundDeep,
         body: SafeArea(
           child: Stack(
             children: [
               // Animated particles background
               const AnimatedParticlesWidget(),
 
               // Gradient overlay
               Container(
                 width: 100.w,
                 height: 100.h,
                 decoration: BoxDecoration(
                   gradient: LinearGradient(
                     begin: Alignment.topCenter,
                     end: Alignment.bottomCenter,
                     colors: [
                       AppTheme.backgroundDeep.withValues(alpha: 0.8),
                       AppTheme.backgroundMid.withValues(alpha: 0.9),
                       AppTheme.backgroundDeep,
                     ],
                     stops: const [0.0, 0.5, 1.0],
                   ),
                 ),
               ),
 
               // Main content
               SingleChildScrollView(
                 child: ConstrainedBox(
                   constraints: BoxConstraints(minHeight: 100.h),
                   child: Column(
                     children: [
                       SizedBox(height: 15.h),
 
                       // App logo with pulsing effect
                       const PulsingLogoWidget(),
 
                       SizedBox(height: 3.h),
 
                       // App title
                       Text(
                         'SOLO FITNESS',
                         style: AppTheme.darkTheme.textTheme.headlineMedium
                             ?.copyWith(
                           color: AppTheme.textPrimary,
                           fontWeight: FontWeight.bold,
                           letterSpacing: 3,
                         ),
                       ),
 
                       SizedBox(height: 1.h),
 
                       // Subtitle
                       Text(
                         'Level Up Your Fitness Journey',
                         style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
                           color: AppTheme.textSecondary,
                           letterSpacing: 1,
                         ),
                       ),
 
                       SizedBox(height: 8.h),
 
-                      // Login buttons with slide animation
+                      // Continue button with slide animation
                       SlideTransition(
                         position: _slideAnimation,
                         child: Column(
                           children: [
-                            // Google Sign In button
-                            GoogleLoginButtonWidget(
-                              onPressed: _handleGoogleSignIn,
-                              isLoading: _isLoading,
-                            ),
-
-                            SizedBox(height: 3.h),
-
-                            // Guest continue button
+                            // Continue button
                             GuestLoginButtonWidget(
-                              onPressed: _handleGuestContinue,
+                              onPressed: _handleContinue,
                             ),
 
                             SizedBox(height: 4.h),
 
                             // Terms and privacy
                             Padding(
                               padding: EdgeInsets.symmetric(horizontal: 8.w),
                               child: Text(
                                 'By continuing, you agree to our Terms of Service and Privacy Policy',
                                 style: AppTheme.darkTheme.textTheme.bodySmall
                                     ?.copyWith(
                                   color: AppTheme.textSecondary
                                       .withValues(alpha: 0.7),
                                   letterSpacing: 0.2,
                                 ),
                                 textAlign: TextAlign.center,
                               ),
                             ),
                           ],
                         ),
                       ),
 
                       SizedBox(height: 5.h),
                     ],
                   ),
                 ),
               ),
 
               // Loading overlay
               LoadingOverlayWidget(
                 isVisible: _isLoading,
-                message: _isLoading ? 'Initializing Quest...' : '',
+                message: _isLoading ? 'Starting Your Journey...' : '',
               ),
-
-              // Particle burst effect on success
-              if (_showParticleEffect)
-                Container(
-                  width: 100.w,
-                  height: 100.h,
-                  child: Center(
-                    child: Container(
-                      width: 50.w,
-                      height: 50.w,
-                      decoration: BoxDecoration(
-                        shape: BoxShape.circle,
-                        gradient: RadialGradient(
-                          colors: [
-                            AppTheme.primaryBlue.withValues(alpha: 0.8),
-                            AppTheme.secondaryPurple.withValues(alpha: 0.6),
-                            AppTheme.accentGold.withValues(alpha: 0.4),
-                            Colors.transparent,
-                          ],
-                        ),
-                      ),
-                    ),
-                  ),
-                ),
             ],
           ),
         ),
       ),
     );
   }
 }
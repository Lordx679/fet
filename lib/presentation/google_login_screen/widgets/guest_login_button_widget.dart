@@ .. @@
 import 'package:flutter/material.dart';
 import 'package:flutter/services.dart';
 import 'package:sizer/sizer.dart';
 
 import '../../../core/app_export.dart';
 
 class GuestLoginButtonWidget extends StatefulWidget {
   final VoidCallback onPressed;
 
   const GuestLoginButtonWidget({
     super.key,
     required this.onPressed,
   });
 
   @override
   State<GuestLoginButtonWidget> createState() => _GuestLoginButtonWidgetState();
 }
 
 class _GuestLoginButtonWidgetState extends State<GuestLoginButtonWidget> {
   bool _isPressed = false;
 
   void _handleTapDown(TapDownDetails details) {
     setState(() => _isPressed = true);
     HapticFeedback.selectionClick();
   }
 
   void _handleTapUp(TapUpDetails details) {
     setState(() => _isPressed = false);
   }
 
   void _handleTapCancel() {
     setState(() => _isPressed = false);
   }
 
   @override
   Widget build(BuildContext context) {
     return GestureDetector(
       onTapDown: _handleTapDown,
       onTapUp: _handleTapUp,
       onTapCancel: _handleTapCancel,
       onTap: widget.onPressed,
       child: AnimatedContainer(
         duration: const Duration(milliseconds: 150),
         width: 85.w,
-        height: 6.h,
+        height: 7.h,
         decoration: BoxDecoration(
           borderRadius: BorderRadius.circular(12),
-          color: Colors.transparent,
-          border: Border.all(
-            color: _isPressed
-                ? AppTheme.secondaryPurple.withValues(alpha: 0.8)
-                : AppTheme.textSecondary.withValues(alpha: 0.3),
-            width: 1.5,
+          gradient: LinearGradient(
+            colors: [
+              AppTheme.primaryBlue.withValues(alpha: _isPressed ? 0.9 : 0.8),
+              AppTheme.primaryBlue.withValues(alpha: _isPressed ? 0.7 : 0.6),
+            ],
+            begin: Alignment.topLeft,
+            end: Alignment.bottomRight,
+          ),
+          border: Border.all(
+            color: AppTheme.primaryBlue.withValues(alpha: 0.8),
+            width: 2,
           ),
           boxShadow: _isPressed
               ? [
                   BoxShadow(
-                    color: AppTheme.secondaryPurple.withValues(alpha: 0.3),
-                    blurRadius: 10,
+                    color: AppTheme.primaryBlue.withValues(alpha: 0.5),
+                    blurRadius: 15,
                     spreadRadius: 2,
+                    offset: const Offset(0, 4),
                   ),
                 ]
-              : null,
+              : [
+                  BoxShadow(
+                    color: AppTheme.primaryBlue.withValues(alpha: 0.3),
+                    blurRadius: 20,
+                    spreadRadius: 5,
+                    offset: const Offset(0, 4),
+                  ),
+                ],
         ),
         child: Center(
           child: Row(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               CustomIconWidget(
-                iconName: 'person_outline',
-                color: _isPressed
-                    ? AppTheme.secondaryPurple
-                    : AppTheme.textSecondary,
+                iconName: 'rocket_launch',
+                color: AppTheme.textPrimary,
                 size: 5.w,
               ),
               SizedBox(width: 2.w),
               Text(
-                'Continue as Guest',
+                'Start Your Journey',
                 style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
-                  color: _isPressed
-                      ? AppTheme.secondaryPurple
-                      : AppTheme.textSecondary,
-                  fontWeight: FontWeight.w500,
-                  letterSpacing: 0.3,
+                  color: AppTheme.textPrimary,
+                  fontWeight: FontWeight.w600,
+                  letterSpacing: 0.5,
                 ),
               ),
             ],
           ),
         ),
       ),
     );
   }
 }
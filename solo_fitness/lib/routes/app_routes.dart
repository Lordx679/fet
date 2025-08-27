import 'package:flutter/material.dart';
import '../presentation/workout_timer_screen/workout_timer_screen.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/google_login_screen/google_login_screen.dart';
import '../presentation/user_onboarding_screen/user_onboarding_screen.dart';
import '../presentation/ai_coach_chat_screen/ai_coach_chat_screen.dart';
import '../presentation/user_profile_screen/user_profile_screen.dart';
import '../presentation/daily_quests_screen/daily_quests_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String workoutTimer = '/workout-timer-screen';
  static const String splash = '/splash-screen';
  static const String googleLogin = '/google-login-screen';
  static const String userOnboarding = '/user-onboarding-screen';
  static const String aiCoachChat = '/ai-coach-chat-screen';
  static const String userProfile = '/user-profile-screen';
  static const String dailyQuests = '/daily-quests-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    workoutTimer: (context) => const WorkoutTimerScreen(),
    splash: (context) => const SplashScreen(),
    googleLogin: (context) => const GoogleLoginScreen(),
    userOnboarding: (context) => const UserOnboardingScreen(),
    aiCoachChat: (context) => const AiCoachChatScreen(),
    userProfile: (context) => const UserProfileScreen(),
    dailyQuests: (context) => const DailyQuestsScreen(),
    // TODO: Add your other routes here
  };
}

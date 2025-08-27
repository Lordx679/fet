import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/chat_input_widget.dart';
import './widgets/chat_message_widget.dart';
import './widgets/coach_header_widget.dart';
import './widgets/typing_indicator_widget.dart';

class AiCoachChatScreen extends StatefulWidget {
  const AiCoachChatScreen({Key? key}) : super(key: key);

  @override
  State<AiCoachChatScreen> createState() => _AiCoachChatScreenState();
}

class _AiCoachChatScreenState extends State<AiCoachChatScreen>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isTyping = false;
  bool _isRecording = false;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  // Mock user data
  final String userName = "Alex";
  final int userLevel = 15;

  @override
  void initState() {
    super.initState();
    _initializeMockData();

    _slideController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
    ));

    _slideController.forward();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _initializeMockData() {
    _messages.addAll([
      {
        "id": 1,
        "content":
            "Welcome back, $userName! 🔥 Ready to crush today's workout? I see you're at Level $userLevel - impressive progress!",
        "isUser": false,
        "timestamp": DateTime.now().subtract(Duration(minutes: 5)),
        "isRead": true,
        "type": "greeting",
      },
      {
        "id": 2,
        "content":
            "Hey coach! Yes, I'm ready. What do you recommend for today?",
        "isUser": true,
        "timestamp": DateTime.now().subtract(Duration(minutes: 4)),
        "isRead": true,
      },
      {
        "id": 3,
        "content":
            "Based on your recent progress, I recommend a strength training session focusing on your upper body. You've been consistent with cardio, so let's build some muscle! 💪",
        "isUser": false,
        "timestamp": DateTime.now().subtract(Duration(minutes: 3)),
        "isRead": true,
        "type": "workout_suggestion",
        "workoutName": "Upper Body Strength Circuit",
      },
      {
        "id": 4,
        "content":
            "That sounds perfect! Also, can you give me some nutrition advice for post-workout?",
        "isUser": true,
        "timestamp": DateTime.now().subtract(Duration(minutes: 2)),
        "isRead": true,
      },
      {
        "id": 5,
        "content":
            "Absolutely! Post-workout nutrition is crucial for recovery. Focus on protein and complex carbs within 30 minutes of finishing your workout. Here's a great option:",
        "isUser": false,
        "timestamp": DateTime.now().subtract(Duration(minutes: 1)),
        "isRead": true,
        "type": "nutrition_advice",
        "mealImage":
            "https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      },
    ]);
  }

  void _sendMessage(String message) {
    if (message.trim().isEmpty) return;

    final newMessage = {
      "id": _messages.length + 1,
      "content": message,
      "isUser": true,
      "timestamp": DateTime.now(),
      "isRead": false,
    };

    setState(() {
      _messages.add(newMessage);
      _isTyping = true;
    });

    _scrollToBottom();
    _simulateCoachResponse(message);
  }

  void _simulateCoachResponse(String userMessage) {
    Future.delayed(Duration(seconds: 2), () {
      if (!mounted) return;

      String response = _generateCoachResponse(userMessage);
      String responseType = _getResponseType(userMessage);

      final coachMessage = {
        "id": _messages.length + 1,
        "content": response,
        "isUser": false,
        "timestamp": DateTime.now(),
        "isRead": true,
        "type": responseType,
        if (responseType == "workout_suggestion")
          "workoutName": "Push-up Challenge",
        if (responseType == "nutrition_advice")
          "mealImage":
              "https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      };

      setState(() {
        _messages.add(coachMessage);
        _isTyping = false;
        // Mark user message as read
        if (_messages.isNotEmpty) {
          final lastUserMessageIndex =
              _messages.lastIndexWhere((msg) => msg['isUser'] == true);
          if (lastUserMessageIndex != -1) {
            _messages[lastUserMessageIndex]['isRead'] = true;
          }
        }
      });

      _scrollToBottom();
    });
  }

  String _generateCoachResponse(String userMessage) {
    final lowerMessage = userMessage.toLowerCase();

    if (lowerMessage.contains('workout') || lowerMessage.contains('exercise')) {
      return "Great question! Based on your current level and recent activity, I recommend focusing on compound movements. They'll give you the best results for your time investment. Ready to start?";
    } else if (lowerMessage.contains('nutrition') ||
        lowerMessage.contains('diet') ||
        lowerMessage.contains('food')) {
      return "Nutrition is 70% of your fitness journey! Focus on whole foods, adequate protein (1g per lb of body weight), and stay hydrated. What's your current eating schedule like?";
    } else if (lowerMessage.contains('progress') ||
        lowerMessage.contains('track')) {
      return "Your progress has been amazing! You've gained 250 XP this week and completed 4 workouts. Keep this momentum going and you'll reach Level ${userLevel + 1} soon! 🚀";
    } else if (lowerMessage.contains('goal') ||
        lowerMessage.contains('target')) {
      return "Setting clear goals is key to success! Let's break down your main objective into smaller, achievable milestones. What's your primary fitness goal right now?";
    } else {
      return "I'm here to help you succeed! Whether it's workout planning, nutrition guidance, or motivation - just ask. Your dedication at Level $userLevel shows you're serious about your fitness journey! 💪";
    }
  }

  String _getResponseType(String userMessage) {
    final lowerMessage = userMessage.toLowerCase();

    if (lowerMessage.contains('workout') || lowerMessage.contains('exercise')) {
      return "workout_suggestion";
    } else if (lowerMessage.contains('nutrition') ||
        lowerMessage.contains('diet') ||
        lowerMessage.contains('food')) {
      return "nutrition_advice";
    } else {
      return "general";
    }
  }

  void _handleVoiceInput() {
    setState(() {
      _isRecording = !_isRecording;
    });

    if (_isRecording) {
      // Start voice recording
      Future.delayed(Duration(seconds: 3), () {
        if (mounted && _isRecording) {
          setState(() {
            _isRecording = false;
          });
          _sendMessage("Show me today's workout plan");
        }
      });
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _refreshMessages() async {
    await Future.delayed(Duration(seconds: 1));
    // Load more messages or refresh current ones
    setState(() {
      // Simulate loading older messages
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDeep,
      body: SlideTransition(
        position: _slideAnimation,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.backgroundDeep,
                AppTheme.backgroundMid.withValues(alpha: 0.3),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              CoachHeaderWidget(
                userLevel: userLevel,
                userName: userName,
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refreshMessages,
                  backgroundColor: AppTheme.backgroundMid,
                  color: AppTheme.primaryBlue,
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.only(bottom: 2.h),
                    itemCount: _messages.length + (_isTyping ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _messages.length && _isTyping) {
                        return TypingIndicatorWidget(isVisible: _isTyping);
                      }

                      final message = _messages[index];
                      return ChatMessageWidget(
                        message: message,
                        isUser: message['isUser'] as bool,
                      );
                    },
                  ),
                ),
              ),
              ChatInputWidget(
                onSendMessage: _sendMessage,
                onVoiceInput: _handleVoiceInput,
                isRecording: _isRecording,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ChatInputWidget extends StatefulWidget {
  final Function(String) onSendMessage;
  final Function() onVoiceInput;
  final bool isRecording;

  const ChatInputWidget({
    Key? key,
    required this.onSendMessage,
    required this.onVoiceInput,
    this.isRecording = false,
  }) : super(key: key);

  @override
  State<ChatInputWidget> createState() => _ChatInputWidgetState();
}

class _ChatInputWidgetState extends State<ChatInputWidget>
    with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _hasText = false;

  final List<String> quickReplies = [
    'Show me today\'s workout',
    'Nutrition advice',
    'Track my progress',
    'Set a new goal',
  ];

  @override
  void initState() {
    super.initState();
    _textController.addListener(_onTextChanged);

    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    if (widget.isRecording) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(ChatInputWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRecording != oldWidget.isRecording) {
      if (widget.isRecording) {
        _pulseController.repeat(reverse: true);
      } else {
        _pulseController.stop();
        _pulseController.reset();
      }
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _hasText = _textController.text.trim().isNotEmpty;
    });
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      widget.onSendMessage(text);
      _textController.clear();
      setState(() {
        _hasText = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundMid,
        border: Border(
          top: BorderSide(
            color: AppTheme.primaryBlue.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildQuickReplies(),
            _buildInputArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickReplies() {
    return Container(
      height: 6.h,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: quickReplies.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(right: 2.w),
            child: ActionChip(
              label: Text(
                quickReplies[index],
                style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textPrimary,
                  fontSize: 10.sp,
                ),
              ),
              backgroundColor: AppTheme.backgroundDeep,
              side: BorderSide(
                color: AppTheme.primaryBlue.withValues(alpha: 0.3),
                width: 1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.w),
              ),
              onPressed: () {
                widget.onSendMessage(quickReplies[index]);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.backgroundDeep,
                borderRadius: BorderRadius.circular(6.w),
                border: Border.all(
                  color: AppTheme.primaryBlue.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Ask your AI coach...',
                        hintStyle:
                            AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondary.withValues(alpha: 0.7),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 4.w,
                          vertical: 2.h,
                        ),
                      ),
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: widget.isRecording ? _pulseAnimation.value : 1.0,
                        child: GestureDetector(
                          onTap: widget.onVoiceInput,
                          child: Container(
                            margin: EdgeInsets.all(2.w),
                            padding: EdgeInsets.all(2.w),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: widget.isRecording
                                    ? [
                                        AppTheme.errorRed,
                                        AppTheme.warningOrange
                                      ]
                                    : [
                                        AppTheme.secondaryPurple,
                                        AppTheme.primaryBlue
                                      ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: widget.isRecording
                                      ? AppTheme.errorRed.withValues(alpha: 0.3)
                                      : AppTheme.secondaryPurpleGlow,
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: CustomIconWidget(
                              iconName: widget.isRecording ? 'stop' : 'mic',
                              color: AppTheme.textPrimary,
                              size: 5.w,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 2.w),
          AnimatedContainer(
            duration: Duration(milliseconds: 200),
            child: GestureDetector(
              onTap: _hasText ? _sendMessage : null,
              child: Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: _hasText
                      ? LinearGradient(
                          colors: [AppTheme.primaryBlue, AppTheme.accentGold],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: _hasText ? null : AppTheme.backgroundDeep,
                  border: Border.all(
                    color: _hasText
                        ? Colors.transparent
                        : AppTheme.textSecondary.withValues(alpha: 0.3),
                    width: 1,
                  ),
                  boxShadow: _hasText
                      ? [
                          BoxShadow(
                            color: AppTheme.primaryBlueGlow,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: CustomIconWidget(
                  iconName: 'send',
                  color: _hasText
                      ? AppTheme.textPrimary
                      : AppTheme.textSecondary.withValues(alpha: 0.5),
                  size: 5.w,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

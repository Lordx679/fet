import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../daily_quests_screen/widgets/floating_particles_widget.dart';
import '../daily_quests_screen/widgets/quest_card_widget.dart';
import '../daily_quests_screen/widgets/quest_category_tabs_widget.dart';
import '../daily_quests_screen/widgets/quest_header_widget.dart';
import '../daily_quests_screen/widgets/weekly_challenge_banner_widget.dart';

class DailyQuestsScreen extends StatefulWidget {
  const DailyQuestsScreen({super.key});

  @override
  State<DailyQuestsScreen> createState() => _DailyQuestsScreenState();
}

class _DailyQuestsScreenState extends State<DailyQuestsScreen>
    with TickerProviderStateMixin {
  late AnimationController _particleController;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  String selectedCategory = 'All';
  bool isRefreshing = false;

  final List<Quest> dailyQuests = [
    Quest(
      id: '1',
      title: 'Morning Strength',
      description: 'Complete 3 sets of push-ups',
      category: 'Strength Training',
      xpReward: 150,
      progress: 0.7,
      isCompleted: false,
      difficulty: QuestDifficulty.bronze,
      icon: Icons.fitness_center,
      requirements: ['20 push-ups', '15 squats', '10 burpees'],
    ),
    Quest(
      id: '2',
      title: 'Cardio Blast',
      description: 'Run 5km or equivalent cardio',
      category: 'Cardio',
      xpReward: 200,
      progress: 0.3,
      isCompleted: false,
      difficulty: QuestDifficulty.silver,
      icon: Icons.directions_run,
      requirements: ['5km run', '30min cardio', 'Heart rate 150+'],
    ),
    Quest(
      id: '3',
      title: 'Hydration Hero',
      description: 'Drink 8 glasses of water',
      category: 'Hydration',
      xpReward: 100,
      progress: 0.8,
      isCompleted: false,
      difficulty: QuestDifficulty.bronze,
      icon: Icons.local_drink,
      requirements: ['8 glasses water', '2L total', 'Track intake'],
    ),
    Quest(
      id: '4',
      title: 'Sleep Master',
      description: 'Get 8 hours of quality sleep',
      category: 'Sleep',
      xpReward: 120,
      progress: 1.0,
      isCompleted: true,
      difficulty: QuestDifficulty.bronze,
      icon: Icons.bedtime,
      requirements: ['8 hours sleep', 'Before 11 PM', 'No screen 1hr before'],
    ),
    Quest(
      id: '5',
      title: 'Iron Warrior',
      description: 'Complete full body strength training',
      category: 'Strength Training',
      xpReward: 300,
      progress: 0.0,
      isCompleted: false,
      difficulty: QuestDifficulty.gold,
      icon: Icons.sports_gymnastics,
      requirements: [
        'Upper body',
        'Lower body',
        'Core exercises',
        '1hr session'
      ],
    ),
  ];

  List<Quest> get filteredQuests {
    if (selectedCategory == 'All') return dailyQuests;
    return dailyQuests
        .where((quest) => quest.category == selectedCategory)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _particleController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutQuart,
    ));

    _slideController.forward();
  }

  @override
  void dispose() {
    _particleController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _refreshQuests() async {
    setState(() {
      isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isRefreshing = false;
      // Reset progress for demonstration
      for (var quest in dailyQuests) {
        if (!quest.isCompleted) {
          quest.progress = (quest.progress + 0.1).clamp(0.0, 1.0);
        }
      }
    });
  }

  void _onQuestTap(Quest quest) {
    if (quest.isCompleted) {
      // Handle reward claiming
      _claimReward(quest);
    } else {
      // Navigate to relevant section (workout timer, water tracker, etc.)
      _startQuest(quest);
    }
  }

  void _claimReward(Quest quest) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Reward Claimed!',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.accentGold,
              ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.stars,
              size: 48,
              color: AppTheme.accentGold,
            ),
            SizedBox(height: 2.h),
            Text(
              '+${quest.xpReward} XP',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppTheme.primaryBlue,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Great job completing "${quest.title}"!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _startQuest(Quest quest) {
    switch (quest.category) {
      case 'Strength Training':
      case 'Cardio':
        Navigator.pushNamed(context, AppRoutes.workoutTimer, arguments: quest);
        break;
      case 'Hydration':
        // Navigate to water tracker (placeholder)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Opening ${quest.category} tracker...'),
            backgroundColor: AppTheme.primaryBlue,
          ),
        );
        break;
      case 'Sleep':
        // Navigate to sleep tracker (placeholder)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Opening ${quest.category} tracker...'),
            backgroundColor: AppTheme.primaryBlue,
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDeep,
      body: Stack(
        children: [
          // Floating particles background
          FloatingParticlesWidget(
            controller: _particleController,
          ),
          // Main content
          SafeArea(
            child: RefreshIndicator(
              onRefresh: _refreshQuests,
              color: AppTheme.primaryBlue,
              backgroundColor: AppTheme.backgroundMid,
              child: CustomScrollView(
                slivers: [
                  // App Bar
                  SliverAppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    floating: true,
                    pinned: false,
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () => Navigator.pop(context),
                    ),
                    title: Text(
                      'Daily Quests',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: AppTheme.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: isRefreshing ? null : _refreshQuests,
                      ),
                    ],
                  ),
                  // Content
                  SliverToBoxAdapter(
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 2.h),
                          // Quest Header
                          QuestHeaderWidget(),
                          SizedBox(height: 3.h),
                          // Weekly Challenge Banner
                          WeeklyChallengeBannerWidget(),
                          SizedBox(height: 3.h),
                          // Category Tabs
                          QuestCategoryTabsWidget(
                            selectedCategory: selectedCategory,
                            onCategorySelected: (category) {
                              setState(() {
                                selectedCategory = category;
                              });
                            },
                          ),
                          SizedBox(height: 2.h),
                          // Quest Cards
                          if (isRefreshing)
                            _buildSkeletonLoading()
                          else
                            ...filteredQuests.asMap().entries.map(
                              (entry) {
                                int index = entry.key;
                                Quest quest = entry.value;
                                return Padding(
                                  padding: EdgeInsets.only(
                                    left: 4.w,
                                    right: 4.w,
                                    bottom: 2.h,
                                  ),
                                  child: QuestCardWidget(
                                    quest: quest,
                                    onTap: () => _onQuestTap(quest),
                                    animationDelay: Duration(
                                      milliseconds: index * 150,
                                    ),
                                  ),
                                );
                              },
                            ).toList(),
                          SizedBox(height: 10.h), // Bottom padding
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonLoading() {
    return Column(
      children: List.generate(
        3,
        (index) => Padding(
          padding: EdgeInsets.only(
            left: 4.w,
            right: 4.w,
            bottom: 2.h,
          ),
          child: Container(
            height: 20.h,
            decoration: BoxDecoration(
              color: AppTheme.backgroundMid,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.primaryBlue.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: const Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryBlue,
                strokeWidth: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Quest Model
class Quest {
  final String id;
  final String title;
  final String description;
  final String category;
  final int xpReward;
  double progress;
  bool isCompleted;
  final QuestDifficulty difficulty;
  final IconData icon;
  final List<String> requirements;

  Quest({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.xpReward,
    required this.progress,
    required this.isCompleted,
    required this.difficulty,
    required this.icon,
    required this.requirements,
  });
}

enum QuestDifficulty { bronze, silver, gold }

extension QuestDifficultyExtension on QuestDifficulty {
  Color get color {
    switch (this) {
      case QuestDifficulty.bronze:
        return const Color(0xFFCD7F32);
      case QuestDifficulty.silver:
        return const Color(0xFFC0C0C0);
      case QuestDifficulty.gold:
        return AppTheme.accentGold;
    }
  }

  String get name {
    switch (this) {
      case QuestDifficulty.bronze:
        return 'Bronze';
      case QuestDifficulty.silver:
        return 'Silver';
      case QuestDifficulty.gold:
        return 'Gold';
    }
  }
}

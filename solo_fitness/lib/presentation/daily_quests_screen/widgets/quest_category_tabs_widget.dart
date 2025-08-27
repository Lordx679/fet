import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../theme/app_theme.dart';

class QuestCategoryTabsWidget extends StatefulWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const QuestCategoryTabsWidget({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  State<QuestCategoryTabsWidget> createState() =>
      _QuestCategoryTabsWidgetState();
}

class _QuestCategoryTabsWidgetState extends State<QuestCategoryTabsWidget>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late List<Animation<Offset>> _slideAnimations;

  final List<QuestCategory> categories = [
    QuestCategory(
      name: 'All',
      icon: Icons.grid_view,
      color: AppTheme.primaryBlue,
      count: 5,
    ),
    QuestCategory(
      name: 'Strength Training',
      icon: Icons.fitness_center,
      color: AppTheme.errorRed,
      count: 2,
    ),
    QuestCategory(
      name: 'Cardio',
      icon: Icons.directions_run,
      color: AppTheme.warningOrange,
      count: 1,
    ),
    QuestCategory(
      name: 'Hydration',
      icon: Icons.local_drink,
      color: AppTheme.primaryBlue,
      count: 1,
    ),
    QuestCategory(
      name: 'Sleep',
      icon: Icons.bedtime,
      color: AppTheme.secondaryPurple,
      count: 1,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimations = List.generate(
      categories.length,
      (index) => Tween<Offset>(
        begin: const Offset(0, 0.5),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _slideController,
        curve: Interval(
          index * 0.1,
          (index * 0.1) + 0.6,
          curve: Curves.easeOutCubic,
        ),
      )),
    );

    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12.h,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => SizedBox(width: 3.w),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = widget.selectedCategory == category.name;

          return SlideTransition(
            position: _slideAnimations[index],
            child: _buildCategoryTab(category, isSelected),
          );
        },
      ),
    );
  }

  Widget _buildCategoryTab(QuestCategory category, bool isSelected) {
    return GestureDetector(
      onTap: () => widget.onCategorySelected(category.name),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(
          horizontal: 4.w,
          vertical: 2.h,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? category.color.withValues(alpha: 0.2)
              : AppTheme.backgroundMid,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? category.color.withValues(alpha: 0.6)
                : AppTheme.textSecondary.withValues(alpha: 0.2),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: category.color.withValues(alpha: 0.3),
                blurRadius: 8,
                spreadRadius: 1,
                offset: const Offset(0, 2),
              ),
            BoxShadow(
              color: AppTheme.shadowBlue,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon with glow effect
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: isSelected
                    ? category.color.withValues(alpha: 0.3)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: category.color.withValues(alpha: 0.4),
                          blurRadius: 6,
                          spreadRadius: 1,
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                category.icon,
                size: 24.sp,
                color: isSelected ? category.color : AppTheme.textSecondary,
              ),
            ),
            SizedBox(height: 1.h),
            // Category name
            Text(
              category.name,
              style: GoogleFonts.inter(
                fontSize: 11.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color:
                    isSelected ? AppTheme.textPrimary : AppTheme.textSecondary,
                letterSpacing: 0.25,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 0.5.h),
            // Quest count badge
            if (category.count > 0)
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 2.w,
                  vertical: 0.3.h,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? category.color
                      : AppTheme.textSecondary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${category.count}',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? AppTheme.textPrimary
                        : AppTheme.textSecondary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class QuestCategory {
  final String name;
  final IconData icon;
  final Color color;
  final int count;

  QuestCategory({
    required this.name,
    required this.icon,
    required this.color,
    required this.count,
  });
}

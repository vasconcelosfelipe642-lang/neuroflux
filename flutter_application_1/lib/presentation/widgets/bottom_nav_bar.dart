import 'package:flutter/material.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_scope.dart';
import 'bottom_nav_item.dart';
import 'nav_tab.dart';

class AppBottomNavBar extends StatelessWidget {
  final NavTab currentTab;
  final ValueChanged<NavTab> onTabChanged;

  const AppBottomNavBar({
    super.key,
    required this.currentTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    ThemeScope.watch(context);

    return Container(
      height: AppSizes.bottomNavHeight,
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
      ),
      child: Row(
        children: [
          BottomNavItem(
            icon: Icons.check_box_outlined,
            label: AppStrings.navTasks,
            isActive: currentTab == NavTab.tasks,
            onTap: () => onTabChanged(NavTab.tasks),
          ),
          BottomNavItem(
            icon: Icons.trending_up_rounded,
            label: AppStrings.navProgress,
            isActive: currentTab == NavTab.progress,
            onTap: () => onTabChanged(NavTab.progress),
          ),
        ],
      ),
    );
  }
}

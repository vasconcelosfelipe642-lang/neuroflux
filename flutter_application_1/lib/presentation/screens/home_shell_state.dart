import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_rebuild.dart';
import '../../core/theme/theme_scope.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/nav_tab.dart';
import 'progress_screen.dart';
import 'tasks_screen.dart';
import 'home_shell.dart';

class HomeShellState extends State<HomeShell> {
  NavTab _currentTab = NavTab.tasks;

  @override
  Widget build(BuildContext context) {
    return ThemeRebuild(
      builder: (context) {
        ThemeScope.watch(context);

        return Scaffold(
          backgroundColor: AppColors.background,
          body: IndexedStack(
            index: _currentTab.index,
            children: [
              TasksScreen(user: widget.user, onLogout: widget.onLogout),
              ProgressScreen(user: widget.user, onLogout: widget.onLogout),
            ],
          ),
          bottomNavigationBar: AppBottomNavBar(
            currentTab: _currentTab,
            onTabChanged: (tab) => setState(() => _currentTab = tab),
          ),
        );
      },
    );
  }
}

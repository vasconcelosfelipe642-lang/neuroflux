import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/screens/register_screen.dart';
import 'core/theme/app_theme.dart';
import 'domain/models/task_model.dart';
import 'presentation/screens/tasks_screen.dart';
import 'presentation/screens/progress_screen.dart';
import 'presentation/widgets/bottom_nav_bar.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const RegisterScreen(),
    );
  }
}


class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  NavTab _currentTab = NavTab.tasks;

 
  final List<TaskModel> _tasks = [];

  void _onTabChanged(NavTab tab) {
    setState(() => _currentTab = tab);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentTab.index,
        children: [
          TasksScreen(
            tasks: _tasks,
            onTasksChanged: (updated) => setState(() {
              _tasks
                ..clear()
                ..addAll(updated);
            }),
          ),
          ProgressScreen(tasks: _tasks),
        ],
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentTab: _currentTab,
        onTabChanged: _onTabChanged,
      ),
    );
  }
}

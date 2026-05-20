import 'package:flutter/material.dart';

import 'pomodoro_timer_sheet_state.dart';

class PomodoroTimerSheet extends StatefulWidget {
  final String taskTitle;

  const PomodoroTimerSheet({super.key, required this.taskTitle});

  static Future<void> show(BuildContext context, {required String taskTitle}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => PomodoroTimerSheet(taskTitle: taskTitle),
    );
  }

  @override
  State<PomodoroTimerSheet> createState() => PomodoroTimerSheetState();
}

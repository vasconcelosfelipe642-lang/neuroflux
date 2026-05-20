import 'package:flutter/material.dart';

import 'day_progress_card_state.dart';

class DayProgressCard extends StatefulWidget {
  final int completedTasks;
  final int totalTasks;
  final VoidCallback? onDayCompleted;

  const DayProgressCard({
    super.key,
    required this.completedTasks,
    required this.totalTasks,
    this.onDayCompleted,
  });

  @override
  State<DayProgressCard> createState() => DayProgressCardState();
}

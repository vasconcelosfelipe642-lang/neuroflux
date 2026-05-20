import 'package:flutter/material.dart';

import '../../domain/models/user_model.dart';
import 'tasks_screen_state.dart';

class TasksScreen extends StatefulWidget {
  final UserModel user;
  final Future<void> Function() onLogout;

  const TasksScreen({super.key, required this.user, required this.onLogout});

  @override
  State<TasksScreen> createState() => TasksScreenState();
}

import 'package:flutter/material.dart';

import '../../domain/models/user_model.dart';
import 'progress_screen_state.dart';

class ProgressScreen extends StatefulWidget {
  final UserModel user;
  final Future<void> Function() onLogout;

  const ProgressScreen({super.key, required this.user, required this.onLogout});

  @override
  State<ProgressScreen> createState() => ProgressScreenState();
}

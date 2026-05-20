import 'package:flutter/material.dart';

import '../../../domain/models/user_model.dart';
import 'admin_dashboard_screen_state.dart';

class AdminDashboardScreen extends StatefulWidget {
  final UserModel admin;
  final Future<void> Function() onLogout;

  const AdminDashboardScreen({
    super.key,
    required this.admin,
    required this.onLogout,
  });

  @override
  State<AdminDashboardScreen> createState() => AdminDashboardScreenState();
}

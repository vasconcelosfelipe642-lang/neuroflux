import 'package:flutter/material.dart';

import '../../../domain/models/user_model.dart';
import 'admin_users_screen_state.dart';

class AdminUsersScreen extends StatefulWidget {
  final UserModel admin;
  final Future<void> Function() onLogout;

  const AdminUsersScreen({
    super.key,
    required this.admin,
    required this.onLogout,
  });

  @override
  State<AdminUsersScreen> createState() => AdminUsersScreenState();
}

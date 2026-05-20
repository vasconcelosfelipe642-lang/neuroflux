import 'package:flutter/material.dart';

import '../../../domain/models/user_model.dart';
import 'admin_user_detail_screen_state.dart';

class AdminUserDetailScreen extends StatefulWidget {
  final UserModel admin;
  final String userId;
  final Future<void> Function() onLogout;
  final VoidCallback? onBanned;

  const AdminUserDetailScreen({
    super.key,
    required this.admin,
    required this.userId,
    required this.onLogout,
    this.onBanned,
  });

  @override
  State<AdminUserDetailScreen> createState() => AdminUserDetailScreenState();
}

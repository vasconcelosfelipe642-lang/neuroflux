import 'package:flutter/material.dart';

import '../../domain/models/user_model.dart';
import 'home_shell_state.dart';

/// Shell de navegação entre as abas autenticadas.
class HomeShell extends StatefulWidget {
  final UserModel user;
  final Future<void> Function() onLogout;

  const HomeShell({super.key, required this.user, required this.onLogout});

  @override
  State<HomeShell> createState() => HomeShellState();
}

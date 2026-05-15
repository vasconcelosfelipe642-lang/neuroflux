import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/errors/app_exception.dart';
import 'data/services/auth_service.dart';
import 'domain/models/user_model.dart';
import 'domain/models/auth_form_model.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/register_screen.dart';
import 'presentation/screens/tasks_screen.dart';
import 'presentation/screens/progress_screen.dart';
import 'presentation/widgets/bottom_nav_bar.dart';

void main() {
  runApp(const NeuroFluxApp());
}

class NeuroFluxApp extends StatelessWidget {
  const NeuroFluxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NeuroFlux',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const AuthGate(),
    );
  }
}

/// Controla se exibe auth ou home com base no estado do token.
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final _authService = AuthService.instance;

  UserModel? _user;
  bool _showRegister = false;

  // ── Handlers de auth ──────────────────────────────────────

  Future<void> _onLogin(LoginFormModel form) async {
    final user = await _authService.login(
      email: form.email,
      password: form.password,
    );
    setState(() => _user = user);
  }

  Future<void> _onRegister(RegisterFormModel form) async {
    final user = await _authService.register(
      nome: form.name,
      email: form.email,
      password: form.password,
    );
    setState(() => _user = user);
  }

  void _onLogout() {
    _authService.logout();
    setState(() {
      _user = null;
      _showRegister = false;
    });
  }

  // ── Build ─────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (_user != null) {
      return HomeShell(user: _user!, onLogout: _onLogout);
    }

    if (_showRegister) {
      return RegisterScreen(
        onRegister: _onRegister,
        onNavigateToLogin: () => setState(() => _showRegister = false),
      );
    }

    return LoginScreen(
      onLogin: _onLogin,
      onNavigateToRegister: () => setState(() => _showRegister = true),
    );
  }
}

/// Shell de navegação entre as abas autenticadas.
class HomeShell extends StatefulWidget {
  final UserModel user;
  final VoidCallback onLogout;

  const HomeShell({super.key, required this.user, required this.onLogout});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  NavTab _currentTab = NavTab.tasks;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentTab.index,
        children: [
          TasksScreen(user: widget.user),
          ProgressScreen(user: widget.user),
        ],
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentTab: _currentTab,
        onTabChanged: (tab) => setState(() => _currentTab = tab),
      ),
    );
  }
}

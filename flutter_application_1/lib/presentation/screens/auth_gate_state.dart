import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_scope.dart';
import '../../data/services/auth_service.dart';
import '../../domain/models/login_form_model.dart';
import '../../domain/models/register_form_model.dart';
import '../../domain/models/user_model.dart';
import 'admin/admin_dashboard_screen.dart';
import 'auth_gate.dart';
import 'home_shell.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class AuthGateState extends State<AuthGate> {
  final _authService = AuthService.instance;
  bool _isRestoring = true;
  UserModel? _user;
  bool _showRegister = false;

  @override
  void initState() {
    super.initState();
    _restoreSession();
  }

  Future<void> _restoreSession() async {
    final user = await _authService.restoreSession();
    if (!mounted) return;
    setState(() {
      _user = user;
      _isRestoring = false;
    });
  }

  Future<void> _onLogin(LoginFormModel form) async {
    final user = await _authService.login(
      email: form.email,
      password: form.password,
    );
    if (!mounted) return;
    setState(() {
      _user = user;
      _showRegister = false;
    });
  }

  Future<void> _onRegister(RegisterFormModel form) async {
    final user = await _authService.register(
      nome: form.name,
      email: form.email,
      password: form.password,
      role: form.role,
    );
    if (!mounted) return;
    setState(() {
      _user = user;
      _showRegister = false;
    });
  }

  Future<void> _onLogout() async {
    await _authService.logout();
    if (!mounted) return;
    setState(() {
      _user = null;
      _showRegister = false;
    });
  }

  void _goToRegister() => setState(() => _showRegister = true);

  void _goToLogin() => setState(() => _showRegister = false);

  @override
  Widget build(BuildContext context) {
    ThemeScope.watch(context);

    if (_isRestoring) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_user != null) {
      final user = _user!;
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        transitionBuilder: (child, animation) {
          final offset = Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.easeOutCubic));
          return SlideTransition(
            position: animation.drive(offset),
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        child: user.isAdmin
            ? AdminDashboardScreen(
                key: const ValueKey('admin'),
                admin: user,
                onLogout: _onLogout,
              )
            : HomeShell(
                key: const ValueKey('home'),
                user: user,
                onLogout: _onLogout,
              ),
      );
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      transitionBuilder: (child, animation) {
        final begin = _showRegister ? const Offset(1, 0) : const Offset(-1, 0);
        final offset = Tween<Offset>(begin: begin, end: Offset.zero)
            .chain(CurveTween(curve: Curves.easeOutCubic));
        return SlideTransition(
          position: animation.drive(offset),
          child: child,
        );
      },
      child: _showRegister
          ? RegisterScreen(
              key: const ValueKey('register'),
              onRegister: _onRegister,
              onNavigateToLogin: _goToLogin,
            )
          : LoginScreen(
              key: const ValueKey('login'),
              onLogin: _onLogin,
              onNavigateToRegister: _goToRegister,
            ),
    );
  }
}

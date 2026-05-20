import 'package:flutter/material.dart';
import '../../core/navigation/app_transitions.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_scope.dart';
import '../../data/services/auth_service.dart';
import '../../domain/models/user_model.dart';
import '../../domain/models/auth_form_model.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'home_shell.dart';
import 'admin/admin_dashboard_screen.dart';

/// Controla se exibe auth ou home com base no estado do token.
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final _authService = AuthService.instance;
  bool _isRestoring = true;

  @override
  void initState() {
    super.initState();
    _restoreSession();
  }

  Future<void> _restoreSession() async {
    final user = await _authService.restoreSession();
    if (!mounted) return;
    if (user != null) {
      _navigateToHome(user);
      return;
    }
    setState(() => _isRestoring = false);
  }

  void _navigateToHome(UserModel user) {
    final screen = user.isAdmin
        ? AdminDashboardScreen(
            admin: user,
            onLogout: _onLogout,
          )
        : HomeShell(user: user, onLogout: () => _onLogout());

    Navigator.of(context).pushReplacement(SlidePageRoute(child: screen));
  }

  Future<void> _onLogin(LoginFormModel form) async {
    final user = await _authService.login(
      email: form.email,
      password: form.password,
    );
    if (!mounted) return;
    _navigateToHome(user);
  }

  Future<void> _onRegister(RegisterFormModel form) async {
    final user = await _authService.register(
      nome: form.name,
      email: form.email,
      password: form.password,
    );
    if (!mounted) return;
    _navigateToHome(user);
  }

  Future<void> _onLogout() async {
    await _authService.logout();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      FadePageRoute(child: const AuthGate()),
    );
  }

  void _goToRegister() {
    Navigator.of(context).pushReplacement(
      SlidePageRoute(
        child: RegisterScreen(
          onRegister: _onRegister,
          onNavigateToLogin: _goToLogin,
        ),
      ),
    );
  }

  void _goToLogin() {
    Navigator.of(context).pushReplacement(
      SlidePageRoute(
        child: LoginScreen(
          onLogin: _onLogin,
          onNavigateToRegister: _goToRegister,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeScope.watch(context);

    if (_isRestoring) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return LoginScreen(
      onLogin: _onLogin,
      onNavigateToRegister: _goToRegister,
    );
  }
}

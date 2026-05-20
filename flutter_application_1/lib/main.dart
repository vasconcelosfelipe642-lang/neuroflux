import 'package:flutter/material.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'data/services/auth_service.dart';
import 'domain/models/user_model.dart';
import 'domain/models/auth_form_model.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/register_screen.dart';
import 'presentation/screens/tasks_screen.dart';
import 'presentation/screens/progress_screen.dart';
import 'presentation/screens/admin/admin_dashboard_screen.dart';
import 'presentation/widgets/bottom_nav_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeProvider.instance.init();
  runApp(const NeuroFluxApp());
}

class NeuroFluxApp extends StatelessWidget {
  const NeuroFluxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeProvider.instance,
      builder: (context, _) {
        final themeProvider = ThemeProvider.instance;
        return MaterialApp(
          title: 'NeuroFlux',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeProvider.themeMode,
          builder: (context, child) {
            return ListenableBuilder(
              listenable: themeProvider,
              builder: (context, _) {
                return ColoredBox(
                  color: AppColors.background,
                  child: child ?? const SizedBox.shrink(),
                );
              },
            );
          },
          home: const AuthGate(),
        );
      },
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
  bool _isRestoring = true;

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

  Future<void> _onLogout() async {
    await _authService.logout();
    if (!mounted) return;
    setState(() {
      _user = null;
      _showRegister = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isRestoring) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_user != null) {
      if (_user!.isAdmin) {
        return AdminDashboardScreen(
          admin: _user!,
          onLogout: _onLogout,
        );
      }
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
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _currentTab.index,
        children: [
          TasksScreen(user: widget.user, onLogout: widget.onLogout),
          ProgressScreen(user: widget.user, onLogout: widget.onLogout),
        ],
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentTab: _currentTab,
        onTabChanged: (tab) => setState(() => _currentTab = tab),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'core/theme/theme_scope.dart';
import 'presentation/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeProvider.instance.init();
  runApp(
    ThemeScope(
      child: const NeuroFluxApp(),
    ),
  );
}

class NeuroFluxApp extends StatelessWidget {
  const NeuroFluxApp({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeScope.watch(context);
    final themeProvider = ThemeProvider.instance;

    return MaterialApp(
      title: 'NeuroFlux',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeProvider.themeMode,
      home: const SplashScreen(),
    );
  }
}

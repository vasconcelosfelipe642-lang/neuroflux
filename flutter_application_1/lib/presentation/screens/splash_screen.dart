import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_strings.dart';
import '../../core/navigation/app_transitions.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/theme/theme_scope.dart';
import '../../core/utils/onboarding_storage.dart';
import '../widgets/neuroflux_logo.dart';
import 'auth_gate.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _scheduleNavigation();
  }

  Future<void> _scheduleNavigation() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    if (!mounted) return;

    final onboardingDone = await OnboardingStorage.isCompleted();
    final next = onboardingDone ? const AuthGate() : const OnboardingScreen();

    Navigator.of(context).pushReplacement(FadePageRoute(child: next));
  }

  @override
  Widget build(BuildContext context) {
    ThemeScope.watch(context);
    final isDark = ThemeProvider.instance.isDark;
    final bg = isDark ? const Color(0xFF1A1A2E) : Colors.white;

    return Scaffold(
      backgroundColor: bg,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const NeuroFluxLogo(
              size: 100,
              showName: false,
              showTagline: false,
            )
                .animate()
                .fadeIn(duration: 600.ms, curve: Curves.easeOut)
                .scale(
                  begin: const Offset(0.8, 0.8),
                  end: const Offset(1, 1),
                  duration: 600.ms,
                  curve: Curves.easeOutBack,
                ),
            const SizedBox(height: 20),
            const _SplashBrandName()
                .animate()
                .fadeIn(duration: 400.ms, delay: 400.ms),
            const SizedBox(height: 8),
            Text(
              AppStrings.appTagline,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.2,
                color: isDark ? AppColors.textSecondary : AppColors.textHint,
              ),
            )
                .animate()
                .fadeIn(duration: 300.ms, delay: 700.ms),
          ],
        ),
      ),
    );
  }
}

class _SplashBrandName extends StatelessWidget {
  const _SplashBrandName();

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeProvider.instance.isDark;
    final darkText = isDark ? const Color(0xFFF0F0F5) : const Color(0xFF2D2D3A);

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Neuro ',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: darkText,
              letterSpacing: -0.5,
            ),
          ),
          const TextSpan(
            text: 'Flux',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}

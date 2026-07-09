import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/constants/app_strings.dart';
import '../../core/navigation/fade_page_route.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/theme/theme_scope.dart';
import '../../core/utils/onboarding_storage.dart';
import '../widgets/neuroflux_logo.dart';
import 'auth_gate.dart';
import 'onboarding_screen.dart';
import 'splash_brand_name.dart';
import 'splash_screen.dart';

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _scheduleNavigation();
  }

  Future<void> _scheduleNavigation() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    if (!mounted) return;

    final onboardingDone = await OnboardingStorage.isCompleted();
    if (!mounted) return;

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
            const SplashBrandName()
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

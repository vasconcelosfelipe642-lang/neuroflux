import 'package:flutter/material.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/navigation/fade_page_route.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/theme_scope.dart';
import '../../core/utils/onboarding_storage.dart';
import 'auth_gate.dart';
import 'onboarding_page.dart';
import 'onboarding_page_data.dart';
import 'onboarding_screen.dart';

class OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  static const _pages = [
    OnboardingPageData(
      icon: Icons.checklist_rounded,
      title: 'Organize seu dia',
      subtitle:
          'Crie tarefas e divida em pequenos passos. Seu cérebro agradece.',
    ),
    OnboardingPageData(
      icon: Icons.psychology_rounded,
      title: 'Feito para seu cérebro',
      subtitle:
          'O NeuroFlux foi pensado para quem tem TDAH. Sem julgamentos, sem pressão.',
    ),
    OnboardingPageData(
      icon: Icons.celebration_rounded,
      title: 'Celebre cada conquista',
      subtitle:
          'Cada tarefa concluída é uma vitória real. Pequenas etapas constroem grandes conquistas.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await OnboardingStorage.markCompleted();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      FadePageRoute(child: const AuthGate()),
    );
  }

  void _next() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    } else {
      _finish();
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeScope.watch(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _finish,
                child: Text(
                  'Pular',
                  style: AppTextStyles.authLink.copyWith(fontSize: 14),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return OnboardingPage(
                    key: ValueKey(index),
                    data: _pages[index],
                    pageIndex: index,
                  );
                },
              ),
            ),
            const SizedBox(height: AppSizes.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_pages.length, (i) {
                final active = i == _currentPage;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: active ? 20 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: active ? AppColors.primary : AppColors.border,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
            const SizedBox(height: AppSizes.lg),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.pagePadding,
                vertical: AppSizes.md,
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _next,
                  child: Text(
                    _currentPage == _pages.length - 1 ? 'Começar' : 'Próximo',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'theme_provider.dart';

/// Propaga mudanças de tema para toda a árvore de widgets.
/// Chame [watch] no início de cada [build] que usa [AppColors].
class ThemeScope extends InheritedNotifier<ThemeProvider> {
  ThemeScope({
    super.key,
    required super.child,
  }) : super(notifier: ThemeProvider.instance);

  static ThemeProvider watch(BuildContext context) {
    context.dependOnInheritedWidgetOfExactType<ThemeScope>();
    return ThemeProvider.instance;
  }
}

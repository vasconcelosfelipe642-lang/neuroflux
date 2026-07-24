import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/core/theme/theme_scope.dart';
import 'package:flutter_application_1/presentation/screens/login_screen.dart';

void main() {
  testWidgets('a tela de login exibe a opção de recuperação de senha', (WidgetTester tester) async {
    await tester.pumpWidget(
      ThemeScope(
        child: MaterialApp(
          home: LoginScreen(
            onLogin: (_) async {},
            onNavigateToRegister: () {},
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Esqueci minha senha?'), findsOneWidget);

    await tester.tap(find.text('Esqueci minha senha?'));
    await tester.pumpAndSettle();

    expect(find.text('Recuperar senha'), findsOneWidget);
  });
}

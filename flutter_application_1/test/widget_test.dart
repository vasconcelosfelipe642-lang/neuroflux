import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/core/theme/theme_scope.dart';
import 'package:flutter_application_1/presentation/screens/login_screen.dart';
import 'package:flutter_application_1/presentation/screens/admin/admin_stat_box.dart';
import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('a tela de login exibe a opção de recuperação de senha',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ThemeScope(
        child: MaterialApp(
          home: LoginScreen(
            onLogin: (_) async {},
            onNavigateToRegister: () {},
          ), 
        ), 
      ), 
    ); // pumpWidget
    await tester.pump();

    expect(find.text('Esqueceu sua senha ?'), findsOneWidget);

    await tester.tap(find.text('Esqueceu sua senha ?'));
    await tester.pumpAndSettle();

    expect(find.text('Recuperar senha'), findsOneWidget);
  });

  testWidgets('o app inicializa e exibe o NeuroFluxApp após o splash',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ThemeScope(
        child: const NeuroFluxApp(),
      ),
    );
    await tester.pump();
    expect(find.byType(NeuroFluxApp), findsOneWidget);
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
  });

  testWidgets('AdminStatBox keeps the percentage visible',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ThemeScope(
        child: MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 100,
                child: AdminStatBox(
                  value: '75%',
                  label: 'Taxa de\nConclusão',
                  highlight: true,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(FittedBox), findsOneWidget);
    expect(find.text('75%'), findsOneWidget);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('NeuroFlux app inicia', (WidgetTester tester) async {
    await tester.pumpWidget(const NeuroFluxApp());
    await tester.pump();
    expect(find.byType(NeuroFluxApp), findsOneWidget);
  });
}

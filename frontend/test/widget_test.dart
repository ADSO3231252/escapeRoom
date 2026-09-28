import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/main.dart';

void main() {
  testWidgets('NEXUS-9 app loads correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const Nexus9App());

    expect(find.text('NEXUS-9'), findsWidgets);
  });
}
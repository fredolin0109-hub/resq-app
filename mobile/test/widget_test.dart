import 'package:flutter_test/flutter_test.dart';
import 'package:resq_app/app/app.dart';

void main() {
  testWidgets('ResQLinkApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ResQLinkApp());
    expect(find.byType(ResQLinkApp), findsOneWidget);
  });
}

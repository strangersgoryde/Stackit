import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stack_the_snack/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Mock SharedPreferences
    SharedPreferences.setMockInitialValues({});

    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle(); // Wait for animations/async to settle

    // Verify that the title shows up (Menu)
    expect(find.text('Stack the Snack'), findsOneWidget);
    expect(find.text('Play'), findsOneWidget);
  });
}

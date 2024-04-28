import 'package:flutter/material.dart';
import 'package:flutter_app/features/auth/screens/login.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('LoginScreen UI Test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LoginScreen(),
      ),
    );

    // Verify the presence of email and password fields
    expect(find.byType(TextFormField), findsNWidgets(2));

    // Check for the presence of the login button
    expect(find.text('Confirm'), findsOneWidget);

    // Try to perform a login without entering credentials
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump(); // Rebuild the widget with the updated state

    // Check for error messages (assuming validators are implemented in TextFormField)
    expect(find.text('Enter your Email'), findsOneWidget);
    expect(find.text('Enter your Password'), findsOneWidget);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/features/tutor/test/screens/tutortests.dart';
import 'package:flutter_app/providers/test_provider.dart';

void main() {
  testWidgets('TutorTests UI tests', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider(
          create: (_) => TestProvider(),
          child: TutorTests(),
        ),
      ),
    );

    // Check for CircularProgressIndicator before data loads
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}

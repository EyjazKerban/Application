import 'package:flutter/material.dart';
import 'package:flutter_app/features/tutor/homework/screens/tutorhomework.dart';
import 'package:flutter_app/providers/homework_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('TutorHomework UI Test', (WidgetTester tester) async {
    // Setup the test widgets
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider(
          create: (context) => HomeworkProvider(),
          child: const TutorHomework(),
        ),
      ),
    );

    // Verify the initial loading state
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}

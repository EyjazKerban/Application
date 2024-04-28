import 'package:flutter/material.dart';
import 'package:flutter_app/features/tutor/resource/screens/tutorresources.dart';
import 'package:flutter_app/providers/resource_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('TutorResources UI Test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider(
          create: (context) => ResourceProvider(),
          child: TutorResources(),
        ),
      ),
    );

    // Initially shows a CircularProgressIndicator
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}

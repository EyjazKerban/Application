import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/features/tutor/classrooms/screens/createclassroom.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/providers/classroom_provider.dart';

void main() {
  testWidgets('CreateClassroom UI Test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Provider<ClassroomProvider>(
          create: (_) => ClassroomProvider(),
          child: CreateClassroom(),
        ),
      ),
    );

    // Verify the presence of input fields
    expect(find.byType(TextFormField), findsNWidgets(3));

    // Enter data into the form fields
    await tester.enterText(find.byType(TextFormField).at(0), 'Algebra Class');
    await tester.enterText(find.byType(TextFormField).at(1), 'Mathematics');
    await tester.enterText(find.byType(TextFormField).at(2), 'MATH101');

    // Tap the confirm button
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Verify that the button triggers form validation
    expect(find.text('Enter the class name'), findsNothing);
  });
}

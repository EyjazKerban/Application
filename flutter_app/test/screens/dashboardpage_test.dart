import 'package:flutter/material.dart';
import 'package:flutter_app/features/tutor/dashboard/screens/dashboardpage.dart';
import 'package:flutter_app/features/tutor/test/services/test_service.dart';
import 'package:flutter_app/models/test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

// Mock implementation of TestService
class MockTestService extends TestService {
  @override
  Future<List<Test>> fetchTests(BuildContext context) async {
    return [
      Test(
          id: '1',
          name: 'Math Test',
          classroomID: 'cls1',
          total: 100,
          testResults: [],
          date: DateTime.now()),
      // Add more mock tests as needed
    ];
  }
}

void main() {
  testWidgets('Dashboard UI and interactions', (WidgetTester tester) async {
    await tester.pumpWidget(
      Provider<TestService>(
        create: (_) => MockTestService(),
        child: MaterialApp(
          home: DashboardPage(),
        ),
      ),
    );

    // Check for CircularProgressIndicator during data fetching
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}

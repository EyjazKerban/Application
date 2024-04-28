import 'package:flutter/material.dart';
import 'package:flutter_app/features/tutor/payment/screens/recentpayments.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/providers/payment_provider.dart';

void main() {
  testWidgets('RecentPaymentsPage UI Test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider(
          create: (_) => PaymentProvider(),
          child: RecentPaymentsPage(),
        ),
      ),
    );

    // Check for CircularProgressIndicator during data fetching
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}

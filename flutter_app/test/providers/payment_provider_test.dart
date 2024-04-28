import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/models/payment.dart';
import 'package:flutter_app/providers/payment_provider.dart';

void main() {
  test('Payment Provider Test', () {
    PaymentProvider provider = PaymentProvider();
    expect(provider.currentPayment, isNull);

    var payment = Payment(
      id: '123',
      classroomID: '456',
      month: 'January',
      payments: [],
    );

    provider.setCurrentPayment(payment);
    expect(provider.currentPayment, isNotNull);
    expect(provider.currentPayment!.id, '123');

    provider.clearCurrentPayment();
    expect(provider.currentPayment, isNull);
  });
}

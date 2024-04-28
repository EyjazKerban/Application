import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/models/payment.dart';

void main() {
  test('Payment Model fromMap', () {
    var json = {
      '_id': '123',
      'classroomID': '456',
      'month': 'January',
      'payments': [
        {
          'userID': '789',
          'image': 'url',
          'date': '2021-01-01T12:00:00.000Z',
          'verified': false
        }
      ]
    };

    var payment = Payment.fromMap(json);
    expect(payment.id, '123');
    expect(payment.payments.first.userID, '789');
    expect(payment.payments.first.verified, false);
  });
}

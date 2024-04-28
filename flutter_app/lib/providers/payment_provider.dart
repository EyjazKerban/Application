import 'package:flutter/foundation.dart';
import 'package:flutter_app/models/payment.dart';

class PaymentProvider with ChangeNotifier {
  Payment? _currentPayment;

  Payment? get currentPayment => _currentPayment;

  void setCurrentPayment(Payment payment) {
    _currentPayment = payment;
    notifyListeners();
  }

  void clearCurrentPayment() {
    _currentPayment = null;
    notifyListeners();
  }

  // Add more methods as needed
}

import 'package:flutter/foundation.dart';
import 'package:flutter_app/models/test.dart';

class TestProvider with ChangeNotifier {
  Test? _currentTest;

  Test? get currentTest => _currentTest;

  void setCurrentTest(Test test) {
    _currentTest = test;
    notifyListeners();
  }

  void clearCurrentTest() {
    _currentTest = null;
    notifyListeners();
  }
}

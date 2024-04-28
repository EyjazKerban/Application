import 'package:flutter/foundation.dart';
import 'package:flutter_app/models/homework.dart';


class HomeworkProvider with ChangeNotifier {
  Homework? _currentHomework;

  Homework? get currentHomework => _currentHomework;

  void setCurrentHomework(Homework homework) {
    _currentHomework = homework;
    notifyListeners();
  }

  void clearCurrentHomework() {
    _currentHomework = null;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_app/models/classroom.dart';

class ClassroomProvider with ChangeNotifier {
  Classroom? _currentClassroom;

  Classroom? get currentClassroom => _currentClassroom;

  void setCurrentClassroom(Classroom classroom) {
    _currentClassroom = classroom;
    notifyListeners();
  }

  void clearCurrentClassroom() {
    _currentClassroom = null;
    notifyListeners();
  }
}


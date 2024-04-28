import 'package:flutter/material.dart';
import 'package:flutter_app/models/user.dart';

class SelectedUserProvider extends ChangeNotifier {
  User _selectedUser = User(
      id: '',
      firstname: '',
      lastname: '',
      email: '',
      password: '',
      role: '',
      token: '');

  User get selectedUser => _selectedUser;

  void setSelectedUser(User selectedUser){
    _selectedUser = selectedUser;
    notifyListeners();
  }
}

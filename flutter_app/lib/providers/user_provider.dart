import 'package:flutter/material.dart';
import 'package:flutter_app/models/user.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(
      id: '',
      firstname: '',
      lastname: '',
      email: '',
      password: '',
      role: '',
      token: '');

  User get user => _user;

  void setUser(String user){
    _user = User.fromJson(user);
    notifyListeners();
  }
}

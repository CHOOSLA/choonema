import 'package:flutter/material.dart';
import '../globals/globals.dart';

class UserState extends ChangeNotifier {
  String _id;
  String _password;

  void setId(String id) {
    _id = id;
  }

  void setPasswrod(String password) {
    _password = password;
  }

  String get id => _id;
  String get password => _password;

  get isVisible => _isVisible;
  bool _isVisible = false;
  set isVisible(value) {
    _isVisible = value;
    notifyListeners();
  }

  get isValid => _isValid;
  bool _isValid = false;
  void isValidId(String input) {
    if (input == Global.validEmail.first) {
      _isValid = true;
    } else {
      _isValid = false;
    }
    notifyListeners();
  }
}

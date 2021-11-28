import 'package:flutter/material.dart';
import '../globals/globals.dart';

class UserState extends ChangeNotifier {
  String _id;
  String _password;
  String _movieNum;
  String _cinemaNum;
  String _movieTime;
  String _rowNum;
  String _colNum;

  void setId(String id) {
    _id = id;
  }

  void setPasswrod(String password) {
    _password = password;
  }

  void setMovieNum(String movienum) {
    _movieNum = movienum;
  }

  void setCinemaNum(String cinemanum) {
    _cinemaNum = cinemanum;
  }

  void setMovieTime(String movietime) {
    _movieTime = movietime;
  }

  void setRowNum(String rownum) {
    _rowNum = rownum;
  }

  void setColNum(String colnum) {
    _colNum = colnum;
  }

  String get id => _id;
  String get password => _password;
  String get movienum => _movieNum;
  String get movietime => _movieTime;
  String get cinemanum => _cinemaNum;
  String get rownum => _rowNum;
  String get colnum => _colNum;

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

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../globals/globals.dart';

class UserState extends ChangeNotifier {
  String _id;
  String _password;
  String _movieNum;
  String _cinemaNum;
  String _movieTime;
  String _rowNum;
  String _colNum;
  String _selectTime;
  String _fee;
  String _reservationDate;
  String _evaluate;
  List<Map<String, String>> _reservs;

  UserState() {
    // ignore: deprecated_member_use
    _reservs = new List<Map<String, String>>();
  }
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

  void setSelectTime(String selecttime) {
    _selectTime = selecttime;
  }

  void setFee(String fee) {
    _fee = fee;
  }

  void setReservatioDate(String date) {
    _reservationDate = date;
  }

  void setEvaluate(String evaluate) {
    _evaluate = evaluate;
  }

  void setReserv(Map<String, String> data) {
    _reservs.add(data);
  }

  String get id => _id;
  String get password => _password;
  String get movienum => _movieNum;
  String get movietime => _movieTime;
  String get cinemanum => _cinemaNum;
  String get rownum => _rowNum;
  String get colnum => _colNum;
  String get selecttime => _selectTime;
  String get fee => _fee;
  String get reservationdate => _reservationDate;
  String get evaluate => _evaluate;
  List<Map<String, String>> get reservs => _reservs;

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

  String getTime() {
    DateTime dt = DateTime.parse(movietime);
    return DateFormat('HH:mm').format(dt);
  }
}

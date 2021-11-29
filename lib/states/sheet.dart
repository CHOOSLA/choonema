import 'package:intl/intl.dart';

class Sheet {
  final String cinemaNumber;
  final String rowNumber;
  final String colNUmber;
  final String AB;

  Sheet({this.cinemaNumber, this.rowNumber, this.colNUmber, this.AB});

  factory Sheet.fromJson(Map<String, dynamic> json) {
    return Sheet(
        cinemaNumber: json['cinemaNumber'],
        rowNumber: json['rowNumber'],
        colNUmber: json['colNUmber'],
        AB: json['AB']);
  }

  Map<String, dynamic> tojson() => {
        'cinemaNumber': cinemaNumber,
        'rowNumber': rowNumber,
        'colNUmber': colNUmber,
        'AB': AB
      };
}

import 'package:intl/intl.dart';

class Schedule {
  final String movieNumber;
  final String time;
  final String cinemaNumber;
  final String fee;

  Schedule({this.movieNumber, this.time, this.cinemaNumber, this.fee});

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
        movieNumber: json['movieNumber'],
        time: json['time'],
        cinemaNumber: json['cinemaNumber'],
        fee: json['fee']);
  }

  Map<String, dynamic> tojson() => {
        'movieNumber': movieNumber,
        'time': time,
        'chinemaNumber': cinemaNumber,
        'fee': fee
      };

  String getTime() {
    DateTime dt = DateTime.parse(time);
    return DateFormat('HH:mm').format(dt);
  }
}

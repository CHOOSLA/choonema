import 'package:flutter/material.dart';
import '../globals/globals.dart';

class DateButtonWidget extends StatelessWidget {
  final String title;
  final bool hasBorder;
  VoidCallback onPressed;
  bool isChecked = false;

  DateButtonWidget({this.title, this.hasBorder, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {isChecked = true},
      child: Container(
        width: 70,
        child: Text(
          '30',
          style: (TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)),
        ),
        alignment: Alignment.center,
        margin: EdgeInsets.only(right: 5),
        color: isChecked ? Global.megaboxwhite : Global.megabox,
      ),
    );
  }
}

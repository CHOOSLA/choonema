import 'package:flutter/material.dart';
import '../globals/globals.dart';

class ButtonWidget extends StatelessWidget {
  final String title;
  final bool hasBorder;
  VoidCallback onPressed;

  ButtonWidget({this.title, this.hasBorder, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(0))),
        child: Ink(
          decoration: BoxDecoration(
            color: hasBorder ? Global.white : Global.megabox,
            borderRadius: BorderRadius.circular(10),
            border: hasBorder
                ? Border.all(
                    color: Global.megabox,
                    //width: 1.0,
                  )
                : Border.fromBorderSide(BorderSide.none),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 60.0,
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(
                    color: hasBorder ? Global.megabox : Global.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}

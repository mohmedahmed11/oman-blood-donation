import 'package:flutter/material.dart';

import '../../../constant.dart';

class BaseAlertDialog extends StatelessWidget {
  //When creating please recheck 'context' if there is an error!

  Color _color = Colors.white;

  late String _title;
  late String _content;
  late String _yes;
  late String _no;
  late Function _yesOnPressed;
  late Function _noOnPressed;

  BaseAlertDialog(
      {required String title,
      required String content,
      required Function yesOnPressed,
      required Function noOnPressed,
      String yes = "Yes",
      String no = "No"}) {
    this._title = title;
    this._content = content;
    this._yesOnPressed = yesOnPressed;
    this._noOnPressed = noOnPressed;
    this._yes = yes;
    this._no = no;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // titleTextStyle: TextStyle(fontSize: 20),
      title: new Text(
        this._title,
        textAlign: TextAlign.center,
      ),
      content: new Text(
        this._content,
        textAlign: TextAlign.center,
        textDirection: TextDirection.rtl,
        style: TextStyle(height: 1.5),
      ),
      actionsAlignment: MainAxisAlignment.spaceAround,
      backgroundColor: this._color,
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15)),

      actions: [
        GestureDetector(
          onTap: () {
            this._noOnPressed();
          },
          child: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(bottom: 20.0),
            height: 50,
            width: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: primaryColor, width: 2),
              // color: Colors.orange
              color: primaryColor,
            ),
            child: Text(
              this._no,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
        SizedBox(
          width: 20,
        ),
        GestureDetector(
          onTap: () {
            this._yesOnPressed();
          },
          child: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(bottom: 20.0),
            height: 50,
            width: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: secoundColor, width: 2),
              // color: Colors.orange
              color: secoundColor,
            ),
            child: Text(
              this._yes,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

Dialog leadDialog = Dialog(
  child: Container(
    height: 300.0,
    width: 360.0,
    color: Colors.white,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(15.0),
          child: Text(
            'Choose from Library',
            style: TextStyle(color: Colors.black, fontSize: 22.0),
          ),
        ),
      ],
    ),
  ),
);

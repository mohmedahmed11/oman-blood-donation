// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

class BloodType extends StatelessWidget {
  const BloodType({
    Key? key,
    required this.blodType,
    this.isSelected = false,
    required this.press,
  }) : super(key: key);

  final String blodType;
  final bool isSelected;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: press,
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: isSelected ? Colors.red : Colors.white,
            boxShadow: [
              BoxShadow(
                  offset: Offset.zero,
                  spreadRadius: 0.1,
                  blurRadius: 12,
                  color: Colors.black12)
            ],
          ),
          width: 60,
          height: 60,
          child: Text(
            blodType,
            style: TextStyle(
                // textBaseline: TextWidthBasis.longestLine,
                color: isSelected ? Colors.white : Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}

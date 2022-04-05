import 'package:flutter/material.dart';

import '../../../constant.dart';

class actionsContainer extends StatelessWidget {
  const actionsContainer(
      {Key? key,
      required this.titleText,
      required this.background,
      required this.press(),
      required this.textColor})
      : super(key: key);

  final String titleText;
  final Color background;
  final Color textColor;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: press,
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(top: 30.0),
        height: 50,
        width: size.width * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: primaryColor, width: 2),
          // color: Colors.orange
          color: background,
        ),
        child: Text(
          titleText,
          style: TextStyle(
              color: textColor, fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

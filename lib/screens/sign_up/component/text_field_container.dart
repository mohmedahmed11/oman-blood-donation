import 'package:flutter/material.dart';

class textFeildContainer extends StatelessWidget {
  const textFeildContainer(
      {Key? key,
      required this.textcontroller,
      required this.type,
      required this.placeholder,
      required this.isPassword,
      required this.onSave,
      required this.isRequire,
      this.enabeld = true})
      : super(key: key);

  final TextEditingController textcontroller;
  final TextInputType type;
  final String placeholder;
  final bool isPassword;
  final bool isRequire;
  final bool enabeld;
  final Function(String) onSave;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width * 0.8,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            offset: Offset.zero,
            spreadRadius: 0.1,
            blurRadius: 12,
            color: Colors.black12)
      ], color: Colors.white, borderRadius: BorderRadius.circular(29)),
      child: TextFormField(
        controller: textcontroller,
        textAlign: TextAlign.center,
        keyboardType: type,
        obscureText: isPassword ? true : false,
        decoration: InputDecoration(
          hintText: placeholder,
          border: InputBorder.none,
        ),
        style: TextStyle(fontSize: 18),
        enabled: enabeld,
        validator: (val) {
          if (isRequire) {
            val!.length == 0 ? placeholder : null;
          }
          return null;
        },
        onSaved: (val) {
          onSave(val!);
        },
      ),
    );
  }
}

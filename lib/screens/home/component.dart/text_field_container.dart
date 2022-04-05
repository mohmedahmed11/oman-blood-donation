import 'package:flutter/material.dart';

class textFeildContainer extends StatelessWidget {
  const textFeildContainer(
      {Key? key,
      required this.textcontroller,
      required this.type,
      required this.placeholder,
      required this.isPassword,
      required this.onSave})
      : super(key: key);

  final TextEditingController textcontroller;
  final TextInputType type;
  final String placeholder;
  final bool isPassword;
  final Function(String) onSave;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      width: size.width,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            offset: Offset.zero,
            spreadRadius: 0.1,
            blurRadius: 12,
            color: Colors.black12)
      ], color: Colors.white, borderRadius: BorderRadius.circular(29)),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: textcontroller,
        textAlign: TextAlign.center,
        keyboardType: type,
        obscureText: isPassword ? true : false,
        decoration: InputDecoration(
            hintText: placeholder,
            border: InputBorder.none,
            errorMaxLines: null),
        style: TextStyle(fontSize: 14),
        validator: (val) => val!.length == 0 ? "$placeholder مطلوب" : null,
        maxLength: type == TextInputType.phone ? 9 : null,
        onSaved: (val) {
          onSave(val!);
        },
      ),
    );
  }
}

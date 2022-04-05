import 'package:blood_donation/constant.dart';
import 'package:flutter/material.dart';

class DonaterView extends StatelessWidget {
  const DonaterView({
    Key? key,
    required this.name,
    required this.phone,
    required this.address,
    required this.add,
    required this.call,
    required this.whatsapp,
    this.isSelected = false,
  }) : super(key: key);

  final String name;
  final String phone;
  final String address;
  final VoidCallback add;
  final VoidCallback call;
  final VoidCallback whatsapp;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 160,
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            offset: Offset.zero,
            spreadRadius: 0.1,
            blurRadius: 12,
            color: Colors.black12)
      ], color: Colors.white, borderRadius: BorderRadius.circular(29)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        textDirection: TextDirection.rtl,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  name,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  phone,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
                Text(
                  address,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  softWrap: true,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Container(
              //   width: 60,
              //   height: 50,
              //   // color: primaryColor,
              //   child: Center(
              //     child: Text(
              //       'AB+',
              //       textAlign: TextAlign.center,
              //       style: TextStyle(
              //           fontSize: 22,
              //           fontWeight: FontWeight.w600,
              //           color: primaryColor),
              //     ),
              //   ),
              // ),
              IconButton(
                  onPressed: add,
                  iconSize: 34,
                  icon: Icon(!isSelected ? Icons.add : Icons.done_rounded),
                  color: secoundColor),
              IconButton(
                  onPressed: call,
                  iconSize: 30,
                  icon: Icon(Icons.call_rounded),
                  color: primaryColor),
              IconButton(
                  onPressed: whatsapp,
                  iconSize: 30,
                  icon: Image.asset(
                    "images/whatsapp.png",
                    width: 25,
                    height: 25,
                  ),
                  color: primaryColor),
            ],
          )
        ],
      ),
    );
  }
}

class DonaterRequestView extends StatelessWidget {
  const DonaterRequestView({
    Key? key,
    required this.name,
    required this.phone,
    required this.address,
    required this.add,
    required this.add1,
    required this.call,
    required this.whatsapp,
    this.isSelected = false,
    required this.status,
  }) : super(key: key);

  final String name;
  final String phone;
  final String address;
  final VoidCallback add;
  final VoidCallback add1;
  final VoidCallback call;
  final VoidCallback whatsapp;
  final int status;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 160,
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            offset: Offset.zero,
            spreadRadius: 0.1,
            blurRadius: 12,
            color: Colors.black12)
      ], color: Colors.white, borderRadius: BorderRadius.circular(29)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        textDirection: TextDirection.rtl,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  name,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  phone,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
                Text(
                  address,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  softWrap: true,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Container(
              //   width: 60,
              //   height: 50,
              //   // color: primaryColor,
              //   child: Center(
              //     child: Text(
              //       'AB+',
              //       textAlign: TextAlign.center,
              //       style: TextStyle(
              //           fontSize: 22,
              //           fontWeight: FontWeight.w600,
              //           color: primaryColor),
              //     ),
              //   ),
              // ),
              IconButton(
                  onPressed: call,
                  iconSize: 30,
                  icon: Icon(Icons.call_rounded),
                  color: primaryColor),
              // IconButton(
              //     onPressed: whatsapp,
              //     iconSize: 30,
              //     icon: Image.asset(
              //       "images/whatsapp.png",
              //       width: 25,
              //       height: 25,
              //     ),
              //     color: primaryColor),
              status == 1
                  ? GestureDetector(
                      // onTap: status != 2 ? add : () {},
                      onTap: add1,
                      child: Center(
                        child: Container(
                            padding: EdgeInsets.all(10),
                            width: 70,
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset.zero,
                                      spreadRadius: 0.1,
                                      blurRadius: 12,
                                      color: Colors.black12)
                                ],
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(29)),
                            child: Center(
                                child: Text(
                              status == 1
                                  ? "غير متاح"
                                  : status == 2
                                      ? "تبرع"
                                      : "تم التبرع",
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ))),
                      ),
                    )
                  : Container(),

              GestureDetector(
                onTap: status != 3 ? add : () {},
                // onTap: add,
                child: Center(
                  child: Container(
                      padding: EdgeInsets.all(10),
                      width: 70,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                offset: Offset.zero,
                                spreadRadius: 0.1,
                                blurRadius: 12,
                                color: Colors.black12)
                          ],
                          color: secoundColor,
                          borderRadius: BorderRadius.circular(29)),
                      child: Center(
                          child: Text(
                        status == 1
                            ? "متاح"
                            : status == 2
                                ? "تبرع"
                                : "تم التبرع",
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ))),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

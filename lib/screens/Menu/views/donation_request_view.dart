import 'package:blood_donation/constant.dart';
import 'package:blood_donation/widgeds/blood_type.dart';
import 'package:flutter/material.dart';

class DonaterRequestView extends StatelessWidget {
  const DonaterRequestView({
    Key? key,
    required this.city,
    required this.hospital,
    required this.bloodType,
    required this.fileNumber,
    required this.contactNumber,
    required this.search,
    // this.isDone = false,
  }) : super(key: key);

  final String city;
  final String hospital;
  final String bloodType;
  final String fileNumber;
  final String contactNumber;
  final VoidCallback search;
  // final bool isSelected;

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
                  hospital,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "رقم الملف: $fileNumber",
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  city,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
                Text(
                  "رقم التواصل: $contactNumber",
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
              BloodType(blodType: bloodType, press: () {}),
              // IconButton(
              //     onPressed: () {},
              //     iconSize: 30,
              //     icon: Icon(Icons.space_bar),
              //     color: primaryColor),
              IconButton(
                  onPressed: search,
                  iconSize: 30,
                  icon: Icon(Icons.search),
                  color: primaryColor),
            ],
          )
        ],
      ),
    );
  }
}

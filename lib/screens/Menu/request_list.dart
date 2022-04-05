import 'dart:convert';

import 'package:blood_donation/constant.dart';
import 'package:blood_donation/screens/Menu/views/donation_request_view.dart';
import 'package:blood_donation/screens/home/donaters_list.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'models/donation_request.dart';

class RequestList extends StatefulWidget {
  RequestList({Key? key}) : super(key: key);

  @override
  State<RequestList> createState() => _RequestListState();
}

class _RequestListState extends State<RequestList> {
  late List<DonationRequest> donaterList = [];

  @override
  void initState() {
    super.initState();
    _postData();
  }

  list() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ListView.builder(
            itemCount: donaterList.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              var objc = donaterList[index];
              return DonaterRequestView(
                bloodType: objc.bloodType,
                city: objc.city,
                hospital: objc.hospital,
                contactNumber: objc.contactNumber,
                fileNumber: objc.fileNumber,
                search: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) {
                      return DonatersList(
                        searchCity: objc.city,
                        searchCityId: objc.cityId,
                        bloodType: objc.bloodType,
                        hospitalName: objc.hospital,
                        hospitalId: objc.hospitalId,
                        phone: objc.contactNumber,
                        fileNumber: objc.fileNumber,
                        requestId: objc.id,
                      );
                    }),
                  );
                },
              );

              // DonaterView(
              //   name: objc.hospital,
              //   phone: objc.contactNumber,
              //   address: objc.city,
              //   add: () {
              //     // _postAddData(objc.id.toString());
              //   },
              //   call: () {
              //     // _makingPhoneCall(objc.c); //(phone: objc.phone);
              //   },
              //   whatsapp: () {
              //     // _launchWhatsapp(objc.phone);
              //   },
              //   isSelected: false,
              // ); //Text('${donaterList[index].name}');
            }),
      ),
    );
  }

  _postData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Loading(context);

    // overlay.show();
    var client = http.Client();

    try {
      var url = Uri.http(baseUrl, '$baseUrlShow/orders.php');
      var uriResponse = await client.post(
        url,
        // headers: ,
        body: {'user_id': prefs.getInt("user_id").toString()},
      );

      print(uriResponse.body);
      Navigator.pop(context);
      if (uriResponse.statusCode == 200) {
        var response = jsonDecode(uriResponse.body);
        if (response["status"] as bool == true) {
          if (mounted) {
            setState(() {
              donaterList = response['data']
                  .map<DonationRequest>(
                      (json) => DonationRequest.fromJson(json))
                  .toList();
            });
          }
        } else {
          MotionToast.error(
                  title: Text("عزراً",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
                  layoutOrientation: ORIENTATION.rtl,
                  description: Text(response["message"].toString()))
              .show(context);
        }
      }
    } finally {
      client.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.only(left: 10.0, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: primaryColor,
                      size: 30,
                    ),
                  ),
                  Text(
                    "طلبات البحث",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w700),
                  )
                ],
              ),
            ),
            // SizedBox(
            //   height: 0,
            // ),
            // Container(
            //   width: double.infinity,
            //   height: 100,
            //   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     textDirection: TextDirection.rtl,
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Text(
            //         "المستشفى : $_hospitalName",
            //         textDirection: TextDirection.rtl,
            //         textAlign: TextAlign.right,
            //         style: TextStyle(
            //             color: secoundColor,
            //             fontSize: 14,
            //             fontWeight: FontWeight.w500),
            //       ),
            //       Text(
            //         "رقم الملف : $_fileNumber",
            //         textDirection: TextDirection.rtl,
            //         textAlign: TextAlign.right,
            //         style: TextStyle(
            //             color: secoundColor,
            //             fontSize: 14,
            //             fontWeight: FontWeight.w400),
            //       )
            //     ],
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 10),
            //   child: Row(
            //       textDirection: TextDirection.rtl,
            //       mainAxisAlignment: MainAxisAlignment.spaceAround,
            //       children: [
            //         Container(
            //           width: size.width * 0.8 - 50,
            //           height: 50,
            //           alignment: Alignment.centerRight,
            //           padding:
            //               EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            //           decoration: BoxDecoration(
            //               boxShadow: [
            //                 BoxShadow(
            //                     offset: Offset.zero,
            //                     spreadRadius: 0.1,
            //                     blurRadius: 12,
            //                     color: Colors.black12)
            //               ],
            //               color: Colors.white,
            //               borderRadius: BorderRadius.circular(29)),
            //           child: Text(
            //             _searchCity,
            //             textAlign: TextAlign.right,
            //             style: TextStyle(
            //                 color: Colors.black,
            //                 fontSize: 14,
            //                 fontWeight: FontWeight.w600),
            //           ),
            //         ),
            //         BloodType(blodType: "$_bloodType", press: () {}),
            //       ]),
            // ),
            SizedBox(
              height: 20,
            ),
            list(),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
            // SingleChildScrollView(
            //   child: Container(
            //     padding: EdgeInsets.all(20),
            //     child: Column(
            //       children: [],
            //     ),
            //   ),
            // ),

            // ),
            // Positioned(
            //   top: 0,
            //   height: 50,
            //   width: size.width,
            //   child:
            // ),
          ],
        ),
      ),
    );
  }
}

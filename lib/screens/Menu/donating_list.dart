import 'dart:convert';
import 'dart:io';

import 'package:blood_donation/constant.dart';
import 'package:blood_donation/notification_service.dart';
import 'package:blood_donation/screens/home/component.dart/donation_request.dart';
import 'package:blood_donation/screens/home/component.dart/donater.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class DonatingList extends StatefulWidget {
  DonatingList({Key? key}) : super(key: key);

  @override
  State<DonatingList> createState() => _DonatingListState();
}

class _DonatingListState extends State<DonatingList> {
  late List<DonateRequest> donationList = [];

  NotificationService _notificationService = NotificationService();

//   Future getProjectDetails() async {
//   var result = await http.get( 'https://getProjectList');
//   return result;
// }

  _postData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Loading(context);

    var client = http.Client();
    // overlay.show();
    try {
      var url = Uri.http(baseUrl, '$baseUrlShow/done_donatings.php');
      var uriResponse = await client.post(
        url,
        // headers: ,
        body: {'user_id': prefs.getInt("user_id").toString()},
      );
      // context.loaderOverlay.hide();
      Navigator.pop(context);
      print(uriResponse.body);
      if (uriResponse.statusCode == 200) {
        var response = jsonDecode(uriResponse.body);
        if (response["status"] as bool == true) {
          if (mounted) {
            setState(() {
              donationList = response["data"]
                  .map<DonateRequest>((json) => DonateRequest.fromJson(json))
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
  void initState() {
    super.initState();
    _postData();
  }

  // _confirmRegister() {
  //   var baseDialog = BaseAlertDialog(
  //       title: "نتبيه",
  //       content: "هل ترغب في حذفك من قائمة المتبرعين",
  //       yesOnPressed: () {
  //         Navigator.pop(context);
  //         _donationCancel();
  //       },
  //       noOnPressed: () {},
  //       yes: "موافق",
  //       no: "إلغاء");
  //   showDialog(context: context, builder: (BuildContext context) => baseDialog);
  // }

  list() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ListView.builder(
            itemCount: donationList.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              var objc = donationList[index];
              var fileNumber = objc.fileNumber;
              return DonaterRequestView(
                name: objc.hospital,
                phone: objc.phone,
                address: 'رقم الملف: $fileNumber',
                add: () {
                  _postAddData(
                      objc.id.toString(),
                      objc,
                      objc.isAccepted != 3 ? "accept" : "donate",
                      objc.isAccepted == 1 ? 2 : 3);
                },
                add1: () {
                  _postAddData(objc.id.toString(), objc, "accept", 4);
                },
                call: () {
                  _makingPhoneCall(objc.phone); //(phone: objc.phone);
                },
                whatsapp: () {
                  _launchWhatsapp(objc.phone);
                },
                isSelected: objc.isAccepted == 1 ? true : false,
                status: objc.isAccepted,
              ); //Text('${donaterList[index].name}');
            }),
      ),
    );
  }

  _postAddData(String order_id, DonateRequest orderData, String action,
      int status) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final overlay = LoadingOverlay.of(context);

    var client = http.Client();
    overlay.show();
    try {
      var url = Uri.http(baseUrl, '$baseUrlWrite/order.php');
      var uriResponse = await client.post(
        url,
        // headers: ,
        body: {
          'order_id': order_id,
          'donate_id': prefs.getInt("donation_id").toString(),
          'user_id': prefs.getInt("user_id").toString(),
          'action': action,
          'status': status.toString()
        },
      );
      overlay.hide();
      print(uriResponse.body);
      if (uriResponse.statusCode == 200) {
        var response = jsonDecode(uriResponse.body);
        if (response["status"] as bool == true) {
          _postData();
          if (status == 2) {
            print("sssss");
            prefs.setBool("userAcceptOrder", true);
            prefs.setString("userAcceptOrderAt", DateTime.now().toString());
            prefs.setInt("orderId", orderData.id);
            prefs.setString("orderHospital", orderData.hospital);
            prefs.setString("orderFileNumber", orderData.fileNumber);
            await _notificationService.scheduleNotifications();
          }
          if (action == "donate") {
            prefs.setBool("userIsDonate", true);
            prefs.remove("userAcceptOrderAt");
            if (prefs.getBool("avilabel_to_donate") != null) _donationCancel();
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

  _donationCancel() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // context.loaderOverlay.show();
    var client = http.Client();
    Loading(context);

    try {
      var url = Uri.http(baseUrl, '$baseUrlWrite/donate.php');
      var uriResponse = await client.post(
        url,
        // headers: ,
        body: {
          'donate_id': prefs.getInt("donation_id").toString(),
          'action': 'cancel'
        },
      );
      // context.loaderOverlay.hide();
      Navigator.pop(context);
      print(uriResponse.body);
      if (uriResponse.statusCode == 200) {
        var response = jsonDecode(uriResponse.body);
        if (response["status"] as bool == true) {
          prefs.remove("donation_id");
          prefs.remove("avilabel_to_donate");
          Navigator.pop(context);
          // _postData();
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
      // context.loaderOverlay.hide();
      client.close();
    }
  }

  _makingPhoneCall(String phone) async {
    var url = 'tel:$phone';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchWhatsapp(String phone) async {
    // if (phone.startsWith("0")) {
    var string = phone.substring(1); // ("0", '');
    // }

    var whatsapp = "+968" + string;
    var whatsappURl_android = "whatsapp://send?phone=" +
        whatsapp +
        "&text=السلام عليكم".replaceAll(RegExp(' '), '20%');
    var whatappURL_ios =
        "https://wa.me/$whatsapp?text=${Uri.parse("سلام عليكم")}";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunch(whatappURL_ios)) {
        await launch(whatappURL_ios, forceSafariVC: false);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: new Text("whatsapp no installed")));
      }
    } else {
      // android , web
      if (await canLaunch(whatsappURl_android)) {
        await launch(whatsappURl_android);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: new Text("whatsapp no installed")));
      }
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
                    "الطلبات الواردة",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w700),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            list(),
          ],
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:blood_donation/constant.dart';
import 'package:blood_donation/widgeds/blood_type.dart';
import 'package:flutter/material.dart';
// import 'package:loader_overlay/loader_overlay.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'component.dart/donater.dart';
import 'package:http/http.dart' as http;

class Donater {
  final int id;
  final String name;
  final String phone;
  final String address;
  final int isSelected;
  final double distance;

  Donater(
      {required this.name,
      required this.id,
      required this.phone,
      required this.address,
      required this.isSelected,
      required this.distance});

  factory Donater.fromJson(Map<String, dynamic> json) {
    return Donater(
        id: json['id'],
        name: json['full_name'],
        address: json['address'],
        phone: json['contact_number'],
        isSelected: json['is_selected'],
        distance: json['distance']);
  }
}

class DonatersList extends StatefulWidget {
  DonatersList(
      {Key? key,
      required this.searchCity,
      required this.bloodType,
      required this.hospitalName,
      required this.fileNumber,
      required this.searchCityId,
      required this.phone,
      required this.hospitalId,
      required this.requestId})
      : super(key: key);
  final String searchCity;
  final String bloodType;
  final String hospitalName;
  final String fileNumber;
  final int searchCityId;
  final String phone;
  final int hospitalId;
  final int requestId;
  @override
  _DonatersListState createState() => _DonatersListState();
}

class _DonatersListState extends State<DonatersList> {
  late String _searchCity;
  late String _bloodType;
  late String _hospitalName;
  late String _fileNumber;
  late int _cityId;
  late int _requestId;

  late List<Donater> donaterList = [];

//   Future getProjectDetails() async {
//   var result = await http.get( 'https://getProjectList');
//   return result;
// }

  _postData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    Loading(context);

    var client = http.Client();

    try {
      var url = Uri.http(baseUrl, '$baseUrlShow/donaters.php');
      var uriResponse = await client.post(
        url,
        // headers: ,
        body: {
          'city_id': _cityId.toString(),
          'blood_type': _bloodType.toString(),
          'request_id': _requestId.toString(),
          'user_id': prefs.getInt("user_id").toString()
        },
      );
      print(uriResponse.body);
      Navigator.pop(context);
      if (uriResponse.statusCode == 200) {
        var response = jsonDecode(uriResponse.body);
        if (response["status"] as bool == true) {
          if (mounted) {
            setState(() {
              donaterList = response['data']
                  .map<Donater>((json) => Donater.fromJson(json))
                  .toList();
              donaterList.sort((a, b) => a.distance.compareTo(b.distance));
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
      print("finaly");
      client.close();
    }
  }

  _postAddData(String donate_id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // context.loaderOverlay.show();
    var client = http.Client();

    print({
      'donate_id': donate_id,
      'request_id': _requestId.toString(),
      'user_id': prefs.getInt("user_id").toString(),
      'action': 'add'
    });
    try {
      var url = Uri.http(baseUrl, '$baseUrlWrite/order.php');
      var uriResponse = await client.post(
        url,
        // headers: ,
        body: {
          'donate_id': donate_id,
          'request_id': _requestId.toString(),
          'user_id': prefs.getInt("user_id").toString(),
          'action': 'add'
        },
      );
      // context.loaderOverlay.hide();

      print(uriResponse.body);
      if (uriResponse.statusCode == 200) {
        var response = jsonDecode(uriResponse.body);
        if (response["status"] as bool == true) {
          _postData();
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

  @override
  void initState() {
    super.initState();
    _searchCity = widget.searchCity;
    _bloodType = widget.bloodType;
    _hospitalName = widget.hospitalName;
    _fileNumber = widget.fileNumber;
    _cityId = widget.searchCityId;
    _requestId = widget.requestId;
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
              return DonaterView(
                name: objc.name,
                phone: objc.phone,
                address: objc.address + " " + objc.distance.toString() + " KM",
                add: () {
                  _postAddData(objc.id.toString());
                },
                call: () {
                  _makingPhoneCall(objc.phone); //(phone: objc.phone);
                },
                whatsapp: () {
                  _launchWhatsapp(objc.phone);
                },
                isSelected: objc.isSelected == 1 ? true : false,
              ); //Text('${donaterList[index].name}');
            }),
      ),
    );
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
    Size size = MediaQuery.of(context).size;
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
                    "المتبرعين",
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
              height: 0,
            ),
            Container(
              width: double.infinity,
              // height: 110,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                textDirection: TextDirection.rtl,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "المستشفى : $_hospitalName",
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        color: secoundColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    "رقم الملف : $_fileNumber",
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        color: secoundColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                  textDirection: TextDirection.rtl,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: size.width * 0.8 - 50,
                      height: 50,
                      alignment: Alignment.centerRight,
                      padding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                offset: Offset.zero,
                                spreadRadius: 0.1,
                                blurRadius: 12,
                                color: Colors.black12)
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(29)),
                      child: Text(
                        _searchCity,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    BloodType(blodType: "$_bloodType", press: () {}),
                  ]),
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

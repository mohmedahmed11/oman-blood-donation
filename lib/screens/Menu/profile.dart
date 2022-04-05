import 'dart:convert';

import 'package:blood_donation/constant.dart';
import 'package:blood_donation/screens/Menu/update_account.dart';
import 'package:blood_donation/screens/home/component.dart/alert.dart';
import 'package:blood_donation/screens/home/component.dart/models.dart';
import 'package:blood_donation/screens/launch_screen.dart';
import 'package:blood_donation/screens/sign_up/account_info.dart';
import 'package:blood_donation/screens/sign_up/component/actions_container.dart';
import 'package:blood_donation/widgeds/blood_type.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'donating_list.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late User user;
  late bool _isAilabelToDonate = false;
  @override
  void initState() {
    super.initState();
    user = User(
        name: "",
        id: 0,
        address: "",
        phone: "",
        gender: "",
        bloodType: "",
        age: "",
        email: "",
        avilabelToDonate: 0,
        donating: '',
        request: '',
        password: '');
    _postData();

    _checkisAcilabelToDonate();
  }

  _checkisAcilabelToDonate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('avilabel_to_donate') != null &&
        prefs.getBool('avilabel_to_donate') == true) {
      _isAilabelToDonate = true;
    }
  }

  _postData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var client = http.Client();
    Loading(context);
    try {
      var url = Uri.http(baseUrl, '$baseUrlShow/get_user.php');
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
              user = User.fromJson(response["data"]);
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
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
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
                      "حسابي",
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
              Container(
                width: double.infinity,
                height: 100,
                margin: EdgeInsets.only(bottom: 20),
                // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: BoxDecoration(
                    // boxShadow: [
                    //   BoxShadow(
                    //       offset: Offset.zero,
                    //       spreadRadius: 0.1,
                    //       blurRadius: 12,
                    //       color: Colors.black12)
                    // ],
                    // color: Colors.red,
                    borderRadius: BorderRadius.circular(29)),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  textDirection: TextDirection.rtl,
                  children: [
                    Image.asset(
                      "images/user_real_person.png",
                      width: 100,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            user.name,
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            user.phone,
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            user.address,
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
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                textDirection: TextDirection.rtl,
                children: [
                  _protofluo("عدد التبرعات", user.donating, () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return DonatingList();
                    }));
                  }),
                  _protofluo("طلبات التبرع", user.request, () {}),
                  _protofluo(
                      "متاح للتبرع", _isAilabelToDonate ? "نعم" : "لا", () {})
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  textDirection: TextDirection.rtl,
                  children: [
                    Row(children: [
                      BloodType(
                        blodType: user.bloodType != null ? user.bloodType! : "",
                        press: () {},
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("فصيلة الدم")
                    ]),
                    Row(children: [
                      genderOption(
                        isGenderSelected: false,
                        press: () {},
                        title: user.gender != null ? user.gender! : "",
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("الجنس")
                    ])
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Text("العمر"),
                    SizedBox(
                      width: 20,
                    ),
                    Text(user.age != null ? user.age! : "")
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: actionsContainer(
                    titleText: "تعديل البيانات",
                    background: Colors.white,
                    press: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return UpdateAccount(
                          userData: user,
                        );
                      })).then((_) => setState(() {
                            _postData();
                          }));
                    },
                    textColor: primaryColor),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: actionsContainer(
                    titleText: "تسجيل خروج",
                    background: primaryColor,
                    press: _confirmLogOut,
                    textColor: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
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
          prefs.remove("isLoggedIn");
          prefs.remove("user_id");
          prefs.remove("avilabel_to_donate");
          prefs.remove("userIsDonate");
          prefs.remove("donation_id");
          prefs.remove("userAcceptOrder");
          prefs.remove("userAcceptOrderAt");
          prefs.remove("orderId");
          prefs.remove("orderHospital");
          prefs.remove("orderFileNumber");
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return LaunchScreen();
          }));

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

  _confirmLogOut() async {
    var baseDialog = BaseAlertDialog(
        title: "نتبيه",
        content: "هل ترغب في تسجيل الخروج",
        yesOnPressed: () {
          _donationCancel();
        },
        noOnPressed: () {
          Navigator.of(context).pop();
        },
        yes: "موافق",
        no: "إلغاء");
    showDialog(context: context, builder: (BuildContext context) => baseDialog);
  }

  Widget _protofluo(String title, String data, VoidCallback? taped) {
    return GestureDetector(
      onTap: taped,
      child: Container(
        // width: double.infinity,
        height: 120,
        padding: EdgeInsets.all(10),
        alignment: Alignment.center,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              offset: Offset.zero,
              spreadRadius: 0.1,
              blurRadius: 12,
              color: Colors.black12)
        ], color: Colors.white, borderRadius: BorderRadius.circular(29)),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    // fontSize: 14,
                    // fontWeight: FontWeight.w500,
                    ),
              ),
              Text(
                data,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 22,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

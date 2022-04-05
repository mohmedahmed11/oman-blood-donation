// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names

import 'dart:convert';

import 'package:blood_donation/pushnotification.dart';
import 'package:blood_donation/screens/Menu/donating_list.dart';
import 'package:blood_donation/screens/home/Search_For_donater.dart';
import 'package:blood_donation/screens/home/donate_now.dart';
import 'package:blood_donation/screens/login/login_page.dart';
import 'package:blood_donation/widgeds/blood_type.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

import 'package:http/http.dart' as http;
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant.dart';
import 'HowCanDonate.dart';
import '../Menu/SideMenu.dart';
import 'component.dart/alert.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedBloodTypeIndex = -1;
  int _donationRequests = 0;

  bool isAvilabelToDonate = false;

  bool _isLogedIn = false;

  bool _userHasDonate = false;

  late String donationDate = '';

  late String daysToDonate = '';

  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  LocationData? _userLocation;

  @override
  void initState() {
    super.initState();

    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        print("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          print("New Notification");
          // if (message.data['_id'] != null) {
          //   Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (context) => DemoScreen(
          //         id: message.data['_id'],
          //       ),
          //     ),
          //   );
          // }
        }
      },
    );

    // 2. This method only call when App in forground it mean app must be opened
    FirebaseMessaging.onMessage.listen(
      (message) {
        print("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data11 ${message.data}");
          LocalNotificationService.createanddisplaynotification(
              message); //.display(message);

        }
      },
    );

    // 3. This method only call when App in background and not terminated(not closed)
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        print("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data22 ${message.data['_id']}");
        }
      },
    );
    _getUserLocation();
    _selectedBloodTypeIndex = -1;
    _checkDonatingStatus();
    // getDontateStatus();
    _startTimer();
  }

  Future<void> getDeviceTokenToSendNotification() async {
    final FirebaseMessaging _fcm = FirebaseMessaging.instance;
    final token = await _fcm.getToken();
    deviceTokenToSendPushNotification = token.toString();

    sendTokenToServer(deviceTokenToSendPushNotification);
    print("Token Value $deviceTokenToSendPushNotification");
  }

  sendTokenToServer(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var client = http.Client();

    try {
      var url = Uri.http(baseUrl, '$baseUrlWrite/update_acount.php');
      var uriResponse = await client.post(
        url,
        // headers: headers,
        body: {
          'token': token,
          'user_id': prefs.getInt("user_id").toString(),
          'action': 'token'
        },
      );

      print(uriResponse.body);
      if (uriResponse.statusCode == 200) {
        var response = jsonDecode(uriResponse.body);

        if (response["status"] as bool == true) {
          print("yes");
        }
      }
    } finally {
      client.close();
    }
  }

  // getDontateStatus() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   if (prefs.getBool('isLoggedIn') != null &&
  //       prefs.getBool('isLoggedIn') == true) {
  //     print("test");
  //     _getDonationDate();
  //   }
  // }

  _confirmRegister() {
    var baseDialog = BaseAlertDialog(
        title: "نتبيه",
        content: "لقد قمت بالدخول كزائر يجب عليك انشاء حساب اولاً",
        yesOnPressed: () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return LoginPage();
          }));
        },
        noOnPressed: () {
          print(_selectedBloodTypeIndex);
          Navigator.of(context).pop();
        },
        yes: "موافق",
        no: "إلغاء");
    showDialog(context: context, builder: (BuildContext context) => baseDialog);
  }

  // _confirmCancel() {
  //   var baseDialog = BaseAlertDialog(
  //       title: "",
  //       content: "هل تود الخروج من التطبيق؟",
  //       yesOnPressed: () {
  //         Navigator.pushReplacement(context,
  //             MaterialPageRoute(builder: (BuildContext context) {
  //           return LoginPage();
  //         }));
  //       },
  //       noOnPressed: () {
  //         print(_selectedBloodTypeIndex);
  //         Navigator.of(context).pop();
  //       },
  //       yes: "موافق",
  //       no: "إلغاء");
  //   showDialog(context: context, builder: (BuildContext context) => baseDialog);
  // }

  // late int _lastTimeBackButtonWasTapped;
  // static const exitTimeInMillis = 2000;

  // Future<bool> _handleWillPop() async {
  //   final _currentTime = DateTime.now().millisecondsSinceEpoch;

  //   if (_lastTimeBackButtonWasTapped != null &&
  //       (_currentTime - _lastTimeBackButtonWasTapped) < exitTimeInMillis) {
  //     Scaffold.of(context).removeCurrentSnackBar();
  //     return true;
  //   } else {
  //     _lastTimeBackButtonWasTapped = DateTime.now().millisecondsSinceEpoch;
  //     Scaffold.of(context).removeCurrentSnackBar();
  //     Scaffold.of(context).showSnackBar(
  //       _getExitSnackBar(context),
  //     );
  //     return false;
  //   }
  // }

  // SnackBar _getExitSnackBar(
  //   BuildContext context,
  // ) {
  //   return SnackBar(
  //     content: Text(
  //       'Press BACK again to exit!',
  //       style: TextStyle(color: Colors.white),
  //     ),
  //     backgroundColor: Colors.red,
  //     duration: const Duration(
  //       seconds: 2,
  //     ),
  //     behavior: SnackBarBehavior.floating,
  //   );
  // }

  _startTimer() async {
    // final duration = Duration(seconds: 5);
    // _timer = Timer.periodic(duration, (timers) {
    // Stop the timer when it matches a condition
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setInt('donation_id', 123);
    // prefs.setBool('avilabel_to_donate', true);
    getDeviceTokenToSendNotification();
    // prefs.remove("userIsDonate");
    if (prefs.getBool("userAcceptOrder") != null) {
      print(DateTime.parse(prefs.getString("userAcceptOrderAt")!)
          .difference(DateTime.now())
          .inMinutes);
      print("after");
      if (DateTime.now()
              .difference(DateTime.parse(prefs.getString("userAcceptOrderAt")!))
              .inHours >
          1) {
        // print("object 2 ${prefs.getString("order")!}");
        // return;
        var id = prefs.getInt("orderId");
        var hospital = prefs.getString("orderHospital");
        var fileNumber = prefs.getString("orderFileNumber");
        // DonateRequest order =
        //     data.map<DonateRequest>((json) => DonateRequest.fromJson(json));

        var baseDialog = BaseAlertDialog(
            title: "نتبيه",
            content: "هل تم التبرع ل ${hospital} رقم الملف : ${fileNumber}",
            yesOnPressed: () {
              Navigator.pop(context);
              _postAddData(id.toString(), "donate", 3);
              prefs.setBool("userIsDonate", true);
              prefs.remove("userAcceptOrderAt");
              if (prefs.getBool("avilabel_to_donate") != null)
                _donationCancel();
              _checkisLogedIn();
              prefs.remove("userAcceptOrder");
              prefs.remove("userAcceptOrderAt");
              prefs.remove("orderHospital");
              prefs.remove("orderFileNumber");
            },
            noOnPressed: () {
              Navigator.pop(context);
              _postAddData(id.toString(), "accept", 4);
              prefs.remove("userAcceptOrder");
              prefs.remove("userAcceptOrderAt");
              prefs.remove("orderHospital");
              prefs.remove("orderFileNumber");
              // _donationAccept("4", order_id);
            },
            yes: "نعم",
            no: "لا");
        showDialog(
            context: context, builder: (BuildContext context) => baseDialog);
      }
    }

    _checkisLogedIn();
    // });
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
          // Navigator.pop(context);
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

  _postAddData(String order_id, String action, int status) async {
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
        print(response);
      }
    } finally {
      client.close();
    }
  }

  @override
  void dispose() {
    super.dispose();

    // _timer.cancel();
  }

  @override
  void didUpdateWidget(HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("object update");
    _startTimer();
  }

  _checkDonatingStatus() async {
    // print("object");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('avilabel_to_donate') != null &&
        prefs.getBool('avilabel_to_donate') == true) {
      _checkDonationRequest();
      if (mounted) {
        setState(() {
          isAvilabelToDonate = true;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          isAvilabelToDonate = false;
        });
      }
    }

    if (prefs.getBool('userIsDonate') != null &&
        prefs.getBool('userIsDonate') == true) {
      _userHasDonate = true;

      if (donationDate == '') {
        print("donationDate");
        _getDonationDate();
      } else {
        var date1 = DateTime.parse(donationDate);
        var date2 = date1.add(Duration(days: 60));
        print(donationDate);
        daysToDonate =
            getTimeString(date2.difference(DateTime.now()).inMinutes);
      }
    } else {
      _userHasDonate = false;
    }
  }

  String getTimeString(int value) {
    final int hour = value ~/ 60;
    final int days = hour ~/ 24;
    final int hours = hour % 24;
    final int minutes = value % 60;
    return '${days} ${hours.toString().padLeft(2, "0")}:${minutes.toString().padLeft(2, "0")}';
  }

  _getDonationDate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var client = http.Client();
    // context.loaderOverlay.show();
    // print("donationDate");
    try {
      var url = Uri.http(baseUrl, '$baseUrlShow/donation_date.php');
      var uriResponse = await client.post(
        url,
        body: {
          'user_id': prefs.getInt('user_id').toString(),
        },
      );
      // context.loaderOverlay.hide();

      print(uriResponse.body);
      if (uriResponse.statusCode == 200) {
        var response = jsonDecode(uriResponse.body);
        if (response["status"] as bool == true) {
          if (mounted) {
            setState(() {
              donationDate = response['date'];
              var date1 = DateTime.parse(donationDate);
              var date2 = date1.add(Duration(days: 60));
              var val = date2.difference(DateTime.now()).inMinutes;
              daysToDonate =
                  getTimeString(date2.difference(DateTime.now()).inMinutes);
              if (val > 0) {
                prefs.setBool("userIsDonate", true);
              }
            });
          }
        } else {
          MotionToast.error(
              title: Text("عزراً",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  )),
              layoutOrientation: ORIENTATION.rtl,
              description: Text(
                response["message"].toString(),
                style: TextStyle(fontSize: 12),
              )).show(context);
        }
      }
    } finally {
      client.close();
      // context.loaderOverlay.hide();
    }
  }

  _checkisLogedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('isLoggedIn') != null &&
        prefs.getBool('isLoggedIn') == true) {
      _isLogedIn = true;
      _checkDonatingStatus();
    }
  }

  _confirmBonationRequest(String order_id) {
    var baseDialog = BaseAlertDialog(
        title: "نتبيه",
        content: "يوجد شخص يحتاج إليك",
        yesOnPressed: () {
          Navigator.pop(context);
          _donationAccept("1", order_id);
        },
        noOnPressed: () {
          Navigator.pop(context);
          _donationAccept("4", order_id);
        },
        yes: "موافق",
        no: "إلغاء");
    showDialog(context: context, builder: (BuildContext context) => baseDialog);
  }

  _donationAccept(String status, String order_id) async {
    print(order_id);
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
          'action': "accept",
          'status': status
        },
      );
      overlay.hide();
      print(uriResponse.body);
      if (uriResponse.statusCode == 200) {
        var response = jsonDecode(uriResponse.body);
        if (response["status"] as bool == true) {
          // _postData();
          if (status == "1") {
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return DonatingList();
            })).then((value) => {_startTimer()});
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

  Future<void> _getUserLocation() async {
    Location location = Location();

    // Check if location service is enable
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    // Check if permission is granted
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    final _locationData = await location.getLocation();
    if (mounted) {
      setState(() {
        _userLocation = _locationData;
        print(_userLocation);
      });
    }
  }

  _checkDonationRequest() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var client = http.Client();
    print(prefs.getInt('donation_id').toString());
    // context.loaderOverlay.show();
    try {
      var url = Uri.http(baseUrl, '$baseUrlShow/donation_new_request.php');
      var uriResponse = await client.post(
        url,
        body: {
          'donation_id': prefs.getInt('donation_id').toString(),
          'lat': _userLocation != null
              ? _userLocation!.latitude.toString()
              : '0.0',
          'long': _userLocation != null
              ? _userLocation!.longitude.toString()
              : '0.0'
        },
      );
      // context.loaderOverlay.hide();

      // print(uriResponse);
      if (uriResponse.statusCode == 200) {
        var response = jsonDecode(uriResponse.body);
        if (response["status"] as bool == true) {
          if (mounted) {
            setState(() {
              _donationRequests = response['count'] as int;
              if (response['data'][0] != null)
                _confirmBonationRequest(response['data'][0]['id'].toString());
            });
          }
        }
        // else {
        //   MotionToast.error(
        //           title: Text("عزراً",
        //               style: TextStyle(
        //                 fontWeight: FontWeight.bold,
        //               )),
        //           layoutOrientation: ORIENTATION.rtl,
        //           description: Text(response["message"].toString()))
        //       .show(context);
        // }
      }
    } finally {
      client.close();
      // context.loaderOverlay.hide();
    }
  }

  // _newPageOpen() {}
  DateTime pre_backpress = DateTime.now();

  @override
  Widget build(BuildContext context) {
    List<String> bloodTypes = [
      "A+",
      "A-",
      "B+",
      "B-",
      "AB+",
      "AB-",
      "O+",
      "O-"
    ];
    _getUserLocation();
    return WillPopScope(
      onWillPop: () async {
        final timegap = DateTime.now().difference(pre_backpress);

        final cantExit = timegap >= Duration(seconds: 2);

        pre_backpress = DateTime.now();

        if (cantExit) {
          //show snackbar
          final snack = SnackBar(
            content: Text('اضغط مرة أخري للخروج'),
            duration: Duration(seconds: 2),
          );

          ScaffoldMessenger.of(context).showSnackBar(snack);

          return false; // false will do nothing when back press
        } else {
          return true; // true will exit the app
        }
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          // onDrawerChanged: ,
          // backgroundColor: Colors.white70,
          onDrawerChanged: (val) => {_startTimer()},
          // onEndDrawerChanged: (val) => {print(val)},
          drawer: SideMenu(openNewPage: () {
            print("object sss");
          }), //(openNewPage: _newPageOpen),
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.red),
            title: Text(""),
            backgroundColor: Colors.white,
            shadowColor: Colors.transparent,
          ),
          body: Directionality(
            textDirection: TextDirection.ltr,
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // IconButton(
                          //     onPressed: () {
                          //       Navigator.push(
                          //         context,
                          //         MaterialPageRoute(builder: (BuildContext context) {
                          //           return AboutApp();
                          //         }),
                          //       );
                          //     },
                          //     icon: Icon(
                          //       Icons.info_outlined,
                          //       size: 30,
                          //     )),
                          // IconButton(
                          //     onPressed: () {},
                          //     icon: Icon(
                          //       Icons.menu,
                          //       size: 30,
                          //     )),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: Text(
                              "إختر فصيلة الدم",
                              style: TextStyle(
                                  color: secoundColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          SizedBox(
                            // color: primaryColor,
                            height: 200,
                            width: 380,
                            child: GridView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                // scrollDirection: none,
                                gridDelegate:
                                    SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent: 100),
                                itemCount: bloodTypes.length,
                                itemBuilder: (context, index) {
                                  return BloodType(
                                    blodType: bloodTypes[index],
                                    press: () {
                                      setState(() {
                                        _selectedBloodTypeIndex = index;
                                      });
                                    },
                                    isSelected: _selectedBloodTypeIndex == index
                                        ? true
                                        : false,
                                  );
                                }),
                          ),
                          SizedBox(
                            height: 0,
                          ),
                          _userHasDonate && donationDate != ''
                              ? Text("يمكنك التبرع كل 8 أسابيع مرة واحدة فقط",
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                      color: secoundColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600))
                              : Container(),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            // color: primaryColor,
                            width: double.infinity,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _userHasDonate && donationDate != ''
                                      ? HomeDonateWaite()
                                      : HomeActionsDonate(
                                          isAvilabelToDonate
                                              ? "متاح للتبرع"
                                              : "التبرع الآن",
                                          isAvilabelToDonate,
                                          Icons.bloodtype_rounded, () {
                                          if (isAvilabelToDonate) {
                                            Navigator.push(context,
                                                MaterialPageRoute(builder:
                                                    (BuildContext context) {
                                              return DonatingList();
                                            })).then(
                                                (value) => {_startTimer()});
                                          } else {
                                            if (_selectedBloodTypeIndex != -1) {
                                              if (_isLogedIn) {
                                                Navigator.push(context,
                                                    MaterialPageRoute(builder:
                                                        (BuildContext context) {
                                                  return DonateNow(
                                                    selectedBloodTypeIndex:
                                                        _selectedBloodTypeIndex,
                                                  );
                                                })).then(
                                                    (value) => {_startTimer()});
                                              } else {
                                                _confirmRegister();
                                              }
                                            } else {
                                              MotionToast.error(
                                                  title: Text("عزراً",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      )),
                                                  layoutOrientation:
                                                      ORIENTATION.rtl,
                                                  description: Text(
                                                    "يرجى إختيار فصيلة الدم اولاً",
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  )).show(context);
                                            }
                                          }
                                        }),
                                  HomeActions(
                                      "بحث عن متبرع", Icons.campaign_rounded,
                                      () {
                                    if (_selectedBloodTypeIndex != -1) {
                                      //
                                      if (_isLogedIn) {
                                        Navigator.push(context,
                                            MaterialPageRoute(builder:
                                                (BuildContext context) {
                                          return SearchForDonater(
                                            selectedBloodTypeIndex:
                                                _selectedBloodTypeIndex,
                                          );
                                        })).then((value) => {
                                              _startTimer()
                                            }); //.pushNamed(context, '/search',
                                      } else {
                                        _confirmRegister();
                                      }
                                    } else {
                                      MotionToast.error(
                                          title: Text("عزراً",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              )),
                                          layoutOrientation: ORIENTATION.rtl,
                                          description: Text(
                                            "يرجى إختيار فصيلة الدم اولاً",
                                            style: TextStyle(fontSize: 12),
                                          )).show(context);
                                    }
                                  })
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          GestureDetector(
                            // When the child is tapped, show a snackbar.
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (BuildContext context) {
                                return HowCanDonate();
                              }));
                              // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            },
                            // The custom button
                            child: const Text(
                              "من يمكنه أن يتبرع بالدم؟",
                              style: TextStyle(
                                  color: secoundColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector HomeActionsDonate(
      String title, bool isAvilabel, IconData icon, VoidCallback? onPress) {
    return GestureDetector(
      onTap: onPress,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(5),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: isAvilabel ? Colors.green[800] : Colors.white,
                boxShadow: [
                  BoxShadow(
                      offset: Offset.zero,
                      spreadRadius: 0.1,
                      blurRadius: 12,
                      color: Colors.black12)
                ]),
            width: 120,
            height: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 50,
                  color: isAvilabel ? Colors.white : primaryColor,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      // textBaseline: TextWidthBasis.longestLine,
                      color: isAvilabel ? Colors.white : primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              decoration: BoxDecoration(
                  color: isAvilabel ? primaryColor : Colors.white,
                  borderRadius: BorderRadius.circular(12.5)),
              width: 25,
              height: 25,
              alignment: Alignment.center,
              child: Text(
                _donationRequests.toString(),
                style: TextStyle(color: Colors.white, fontSize: 12),
                // textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }

  Container HomeDonateWaite() {
    return Container(
      padding: EdgeInsets.all(10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                offset: Offset.zero,
                spreadRadius: 0.1,
                blurRadius: 12,
                color: Colors.black12)
          ]),
      width: 120,
      height: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "تبقى لك",
            textAlign: TextAlign.center,
            style: TextStyle(
                // textBaseline: TextWidthBasis.longestLine,
                color: primaryColor,
                fontSize: 14,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 10,
          ),
          Text(daysToDonate.toString(), style: TextStyle(fontSize: 14)),
          SizedBox(
            height: 10,
          ),
          Text(
            "للتبرع مرة أخرى",
            textAlign: TextAlign.center,
            style: TextStyle(
                // textBaseline: TextWidthBasis.longestLine,
                color: primaryColor,
                fontSize: 12,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  GestureDetector HomeActions(
      String title, IconData icon, VoidCallback? onPress) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        padding: EdgeInsets.all(10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  offset: Offset.zero,
                  spreadRadius: 0.1,
                  blurRadius: 12,
                  color: Colors.black12)
            ]),
        width: 120,
        height: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50,
              color: primaryColor,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  // textBaseline: TextWidthBasis.longestLine,
                  color: primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

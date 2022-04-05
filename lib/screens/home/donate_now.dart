import 'dart:convert';
import 'package:blood_donation/constant.dart';
import 'package:blood_donation/screens/home/component.dart/text_field_container.dart';
// import 'package:blood_donation/screens/home/donaters_list.dart';
import 'package:blood_donation/widgeds/blood_type.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
// import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:http/http.dart' as http;
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'component.dart/models.dart';

class DonateNow extends StatefulWidget {
  const DonateNow({Key? key, this.selectedBloodTypeIndex = -1})
      : super(key: key);
  final int selectedBloodTypeIndex;

  @override
  _DonateNowState createState() => _DonateNowState();
}

class _DonateNowState extends State<DonateNow> {
  int _selectedBloodTypeIndex = -1;

  TextEditingController searchPhone = TextEditingController();
  TextEditingController searchAddress = TextEditingController();

  String? fileNumber;
  late int selectedStateId = 0;
  late int selectedCityId = 0;
  String? phone;
  String? city;
  String? state;
  String? address;

  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  LocationData? _userLocation;

  @override
  void initState() {
    super.initState();
    _selectedBloodTypeIndex = widget.selectedBloodTypeIndex;
    _getCityData();

    // print(_selectedBloodTypeIndex);
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

  validate() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      if (selectedStateId == 0) {
        MotionToast.error(
                title: Text("عزراً",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
                layoutOrientation: ORIENTATION.rtl,
                description: Text("الرجاء اختيار المحافظة"))
            .show(context);
        return;
      }

      if (selectedCityId == 0) {
        MotionToast.error(
                title: Text("عزراً",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
                layoutOrientation: ORIENTATION.rtl,
                description: Text("الرجاء اختيار الولاية"))
            .show(context);
        return;
      }

      _postData();
    }
  }

  _postData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Loading(context);

    var client = http.Client();
    // overlay.show();
    try {
      var url = Uri.http(baseUrl, '$baseUrlWrite/donate.php');
      var uriResponse = await client.post(
        url,
        // headers: headers,
        body: {
          'address': address,
          'city_id': selectedCityId.toString(),
          'phone': phone,
          'blood_type': bloodTypes[_selectedBloodTypeIndex],
          'user_id': prefs.getInt("user_id").toString(),
          'action': 'add',
          'lat': _userLocation != null
              ? _userLocation!.latitude.toString()
              : '0.0',
          'long': _userLocation != null
              ? _userLocation!.longitude.toString()
              : '0.0'
        },
      );

      print(uriResponse.body);
      Navigator.pop(context);
      if (uriResponse.statusCode == 200) {
        var response = jsonDecode(uriResponse.body);
        if (response["status"] as bool == true) {
          ///
          prefs.setInt('donation_id', response["donation_id"] as int);
          prefs.setBool('avilabel_to_donate', true);
          Navigator.pop(context);

          ///
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

  _getCityData() async {
    var client = http.Client();

    try {
      var url = Uri.http(baseUrl, '$baseUrlShow/cities.php');
      var uriResponse = await client.post(
        url,
      );

      print(uriResponse.body);
      if (uriResponse.statusCode == 200) {
        var response = jsonDecode(uriResponse.body);
        if (response["status"] as bool == true) {
          if (mounted) {
            setState(() {
              shortItems = response['data']
                  .map<Mayors>((json) => Mayors.fromJson(json))
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

  String? selectedValue;
  List<Mayors> shortItems = [];

  List<City> longItems = [];
  final formKey = new GlobalKey<FormState>();

  // String shortSpinnerValue = shortItems[0];
  // String longSpinnerValue = longItems[0];

  List<String> bloodTypes = ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    _getUserLocation();
    // _getData();
    // final args = ModalRoute.of(context)!.settings.arguments as searchParams;

    // setState(() {
    //   _selectedBloodTypeIndex = args.selectedBloodTypeIndex;
    // });

    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 80,
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "فصيلة الدم",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    // color: primaryColor,
                    height: 200,
                    width: 380,
                    child: GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        // scrollDirection: none,
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
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
                            isSelected:
                                _selectedBloodTypeIndex == index ? true : false,
                          );
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 20),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                      width: size.width,
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
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: DropdownButton(
                          // Initial Value
                          value: state,
                          underline: Container(),
                          // style: TextStyle(),

                          // Down Arrow Icon
                          icon: const Icon(Icons.keyboard_arrow_down),
                          hint: Text(
                            "إختر المحافظة",
                            textAlign: TextAlign.center,
                          ),
                          // alignment: AlignmentDirectional.center,
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontFamily: "tajawal"),
                          // Array list of items
                          items: shortItems.map((items) {
                            return DropdownMenuItem(
                              value: items.name,
                              child: Text(items.name),
                            );
                          }).toList(),
                          // After selecting the desired option,it will
                          // change button value to selected value
                          onChanged: (value) {
                            String item = value as String;
                            print(item);
                            setState(() {
                              var val = shortItems
                                  .where((element) => element.name == item)
                                  .first;
                              selectedStateId = val.id;

                              longItems = val.citys;
                              city = null;
                              selectedCityId = 0;

                              state = item;
                            });
                          },
                        ),
                      ),
                    ),

                    // Text("data")

                    // addCityDropDown(shortItems, 'اختر المنطقة', (val) {
                    //   selectedCityId = val.id;
                    // }),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 20),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                      width: size.width,
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
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: DropdownButton(
                          // Initial Value
                          value: city,
                          underline: Container(),
                          // style: TextStyle(),

                          // Down Arrow Icon
                          icon: const Icon(Icons.keyboard_arrow_down),
                          hint: Text(
                            "إختر الولاية",
                            textAlign: TextAlign.center,
                          ),
                          // alignment: AlignmentDirectional.center,
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontFamily: "tajawal"),
                          // Array list of items
                          items: longItems.map((items) {
                            return DropdownMenuItem(
                              value: items.name,
                              child: Text(items.name),
                            );
                          }).toList(),
                          // After selecting the desired option,it will
                          // change button value to selected value
                          onChanged: (value) {
                            String item = value as String;
                            print(item);
                            setState(() {
                              var val = longItems
                                  .where((element) => element.name == item)
                                  .first;
                              selectedCityId = val.id;
                              city = item;
                            });
                          },
                        ),
                      ),
                    ),

                    // Text("data")

                    // addCityDropDown(shortItems, 'اختر المنطقة', (val) {
                    //   selectedCityId = val.id;
                    // }),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 20),
                    child: textFeildContainer(
                        textcontroller: searchPhone,
                        type: TextInputType.phone,
                        placeholder: "رقم التواصل (0XXXXXXXX)",
                        isPassword: false,
                        onSave: (val) {
                          phone = val;
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 20),
                    child: textFeildContainer(
                        textcontroller: searchAddress,
                        type: TextInputType.text,
                        placeholder: "العنوان",
                        isPassword: false,
                        onSave: (val) {
                          address = val;
                        }),
                  ),
                  _userLocation != null
                      ? Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Wrap(
                            children: [
                              Text('خط العرض : ${_userLocation?.longitude}'),
                              const SizedBox(width: 10),
                              Text('خط الطول: ${_userLocation?.latitude}'),
                            ],
                          ),
                        )
                      : Container(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 0),
                    child: Text(
                      "سيتم إرفاق موقعك الحالي مع البيانات لتتمكن من ايجاد المتبريعن الاقرب لك. ",
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      validate();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment.center,
                      margin:
                          const EdgeInsets.only(top: 30.0, left: 20, right: 20),
                      height: 50,
                      width: size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        // border: Border.all(color: primaryColor, width: 1.5),
                        // color: Colors.orange
                        color: Colors.green[800],
                      ),
                      child: Text(
                        "متاح للتبرع",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 0),
                    child: Text(
                      "* نشكر تفهمك في إمكانية التواصل معك في اي وقت",
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(color: primaryColor, fontSize: 12),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            height: 50,
            width: size.width,
            child: Container(
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
                    "التبرع الآن",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w700),
                  )
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

  int x = 1;

  // DropdownButtonHideUnderline addCityDropDown() {
  //   // return DropdownButtonHideUnderline(
  //   //   child:
  //   // );
  // }
}

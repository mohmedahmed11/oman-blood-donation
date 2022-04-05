import 'dart:convert';
import 'package:blood_donation/constant.dart';
import 'package:blood_donation/screens/home/component.dart/text_field_container.dart';
import 'package:blood_donation/screens/home/donaters_list.dart';
import 'package:blood_donation/widgeds/blood_type.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'component.dart/models.dart';

class SearchForDonater extends StatefulWidget {
  const SearchForDonater({Key? key, this.selectedBloodTypeIndex = -1})
      : super(key: key);
  final int selectedBloodTypeIndex;

  @override
  _SearchForDonaterState createState() => _SearchForDonaterState();
}

class _SearchForDonaterState extends State<SearchForDonater> {
  int _selectedBloodTypeIndex = -1;

  TextEditingController searchPhone = TextEditingController();
  TextEditingController searchFileNumber = TextEditingController();

  String? fileNumber;
  late int selectedCityId = 0;
  late int selectedStateId = 0;
  late int selectedHospitalId = 0;
  String? hospital;
  String? city;
  String? state;
  String? phone;
  @override
  void initState() {
    super.initState();
    _selectedBloodTypeIndex = widget.selectedBloodTypeIndex;
    _getCityData();
    // _getHospitalData();
    // print(_selectedBloodTypeIndex);
  }

  validate() {
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

    if (searchFileNumber == 0) {
      MotionToast.error(
              title: Text("عزراً",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  )),
              layoutOrientation: ORIENTATION.rtl,
              description: Text("الرجاء اختيار المستشى"))
          .show(context);
      return;
    }

    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      _postData();
    }
  }

  _postData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // final overlay = LoadingOverlay.of(context);

    var client = http.Client();
    // overlay.show();
    Loading(context);
    try {
      var url = Uri.http(baseUrl, '$baseUrlWrite/request.php');
      var uriResponse = await client.post(
        url,
        // headers: ,
        body: {
          'phone': phone!,
          'city_id': selectedCityId.toString(),
          'hospital_id': selectedHospitalId.toString(),
          'file_number': fileNumber,
          'blood_type': bloodTypes[_selectedBloodTypeIndex],
          'user_id': prefs.getInt("user_id").toString()
        },
      );

      print(prefs.getInt("user_id").toString());
      Navigator.pop(context);
      if (uriResponse.statusCode == 200) {
        var response = jsonDecode(uriResponse.body);
        if (response["status"] as bool == true) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (BuildContext context) {
              return DonatersList(
                searchCity: city!,
                searchCityId: selectedCityId,
                bloodType: bloodTypes[_selectedBloodTypeIndex],
                hospitalName: hospital!,
                hospitalId: selectedHospitalId,
                phone: phone!,
                fileNumber: searchFileNumber.text,
                requestId: response["request_id"] as int,
              );
            }),
          );
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
      // overlay.hide();

      client.close();
    }
  }

  _getCityData() async {
    var client = http.Client();
    // _showSingleAnimationDialog(context, Indicator.ballGridBeat, true);
    // Loading(context);
    // showDialog(
    //     context: context,
    //     builder: (context) {
    //       return AlertDialog(
    //         title: const SpinKitWave(
    //           color: Color(0xff0C6CAD),
    //           size: 30.0,
    //         ),
    //         // content: Text('Hey! I am Coflutter!'),
    //         // actions: <Widget>[
    //         //   TextButton(
    //         //       onPressed: () {
    //         //         // _dismissDialog();
    //         //       },
    //         //       child: Text('Close')),
    //         //   TextButton(
    //         //     onPressed: () {
    //         //       print('HelloWorld!');
    //         //       // _dismissDialog();
    //         //     },
    //         //     child: Text('HelloWorld!'),
    //         //   )
    //         // ],
    //       );
    //     });
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
              mayorsItems = response['data']
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
      // overlay.hide();
      // Navigator.pop(context);

      client.close();
    }
  }

  // _getHospitalData() async {
  //   // final overlay = LoadingOverlay.of(context);
  //   var client = http.Client();
  //   // overlay.show();
  //   try {
  //     var url = Uri.http(baseUrl, '$baseUrlShow/hospitals.php');
  //     var uriResponse = await client.post(
  //       url,
  //     );

  //     print(uriResponse.body);
  //     if (uriResponse.statusCode == 200) {
  //       var response = jsonDecode(uriResponse.body);
  //       if (response["status"] as bool == true) {
  //         if (mounted) {
  //           setState(() {
  //             longItems = response['data']
  //                 .map<Hospital>((json) => Hospital.fromJson(json))
  //                 .toList();
  //           });
  //         }
  //       } else {
  //         MotionToast.error(
  //                 title: Text("عزراً",
  //                     style: TextStyle(
  //                       fontWeight: FontWeight.bold,
  //                     )),
  //                 layoutOrientation: ORIENTATION.rtl,
  //                 description: Text(response["message"].toString()))
  //             .show(context);
  //       }
  //     }
  //   } finally {
  //     // overlay.hide();
  //     client.close();
  //   }
  // }

  String? selectedValue;
  List<City> shortItems = [];

  List<Mayors> mayorsItems = [];

  List<Hospital> longItems = [];
  final formKey = new GlobalKey<FormState>();

  // String shortSpinnerValue = shortItems[0];
  // String longSpinnerValue = longItems[0];

  List<String> bloodTypes = ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // _getCityData();
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
                          items: mayorsItems.map((items) {
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
                              state = item;
                              var val = mayorsItems
                                  .where((element) => element.name == item)
                                  .first;
                              shortItems = val.citys;
                              city = null;
                              selectedCityId = 0;
                              selectedStateId = val.id;
                            });
                          },
                        ),
                      ),
                    ),
                    // Text("data")
                    //  addCityDropDown(shortItems, 'اختر المنطقة', (val) {
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
                              city = item;
                              var val = shortItems
                                  .where((element) => element.name == item)
                                  .first;
                              longItems = val.hospitals;
                              hospital = null;
                              selectedHospitalId = 0;
                              selectedCityId = val.id;
                            });
                          },
                        ),
                      ),
                    ),
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
                          value: hospital,
                          underline: Container(),
                          // style: TextStyle(),

                          // Down Arrow Icon
                          icon: const Icon(Icons.keyboard_arrow_down),
                          hint: Text(
                            'اختر المستشفى',
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
                              hospital = item;
                              var val = longItems
                                  .where((element) => element.name == item)
                                  .first;
                              selectedHospitalId = val.id;
                              print(val.id);
                            });
                          },
                        ),
                      ),
                    ),

                    // Text("data")
                    //     addHospitalDropDown(longItems, , (val) {
                    //   selectedHospitalId = val.id;
                    // }),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 20),
                    child: textFeildContainer(
                        textcontroller: searchPhone,
                        type: TextInputType.phone,
                        placeholder: "رقم التواصل",
                        isPassword: false,
                        onSave: (val) {
                          phone = val;
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 20),
                    child: textFeildContainer(
                        textcontroller: searchFileNumber,
                        type: TextInputType.number,
                        placeholder: "رقم ملف المريض",
                        isPassword: false,
                        onSave: (val) {
                          fileNumber = val;
                        }),
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
                        border: Border.all(color: primaryColor, width: 1.5),
                        // color: Colors.orange
                        color: primaryColor,
                      ),
                      child: Text(
                        "بحث",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ),
          // _isLooding
          //     ? Positioned.fill(
          //         child: Center(
          //           child: Container(
          //             color: Colors.white,
          //             width: 300.0,
          //             height: 300.0,
          //             child: SpinKitFadingCircle(
          //               itemBuilder: (_, int index) {
          //                 return DecoratedBox(
          //                   decoration: BoxDecoration(
          //                     color: index.isEven ? Colors.red : Colors.green,
          //                   ),
          //                 );
          //               },
          //               size: 120.0,
          //             ),
          //           ),
          //         ),
          //       )
          //     : Stack(),
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
                    "طلب تبرع",
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

  // DropdownButtonHideUnderline addCityDropDown(
  //     List<City> itemsList, String placeholder, Function(City) onSelect) {
  //   return DropdownButtonHideUnderline(
  //     child: DropdownButton2(
  //       // key: new Key('$x++'),
  //       isExpanded: true,
  //       hint: Row(
  //         children: [
  //           // Icon(
  //           //   Icons.list,
  //           //   size: 16,
  //           //   color: Colors.yellow,
  //           // ),
  //           SizedBox(
  //             width: 4,
  //           ),
  //           Expanded(
  //             child: Text(
  //               placeholder,
  //               textAlign: TextAlign.center,
  //               style: TextStyle(
  //                 fontSize: 14,

  //                 // fontWeight: FontWeight.bold,
  //                 // color: Colors.yellow,
  //               ),
  //               overflow: TextOverflow.ellipsis,
  //             ),
  //           ),
  //         ],
  //       ),
  //       items: itemsList
  //           .map((item) => DropdownMenuItem<String>(
  //                 value: item.name,
  //                 // alignment: Alignment.centerRight,
  //                 child: Text(
  //                   item.name,
  //                   // textAlign: TextAlign.right,
  //                   style: const TextStyle(
  //                     fontSize: 14,
  //                     // fontWeight: FontWeight.bold,
  //                     color: Colors.black,
  //                   ),
  //                   overflow: TextOverflow.ellipsis,
  //                 ),
  //               ))
  //           .toList(),
  //       value: city,
  //       onChanged: (value) {
  //         onSelect(shortItems
  //             .where((element) => element.name == value as String)
  //             .first);
  //         String item = value as String;
  //         print(item);
  //         setState(() {
  //           city = item;
  //         });
  //       },
  //       // icon: const Icon(
  //       //   Icons.arrow_forward_ios_outlined,
  //       // ),

  //       alignment: AlignmentDirectional.center,
  //       // style: TextStyle(

  //       // ),
  //       iconSize: 20,
  //       iconEnabledColor: primaryColor,
  //       iconDisabledColor: Colors.grey,
  //       buttonHeight: 50,
  //       buttonWidth: double.infinity,
  //       buttonPadding: const EdgeInsets.only(left: 14, right: 14),
  //       buttonDecoration:
  //           BoxDecoration(borderRadius: BorderRadius.circular(25), boxShadow: [
  //         BoxShadow(
  //             offset: Offset.zero,
  //             spreadRadius: 0.1,
  //             blurRadius: 12,
  //             color: Colors.black12)
  //       ]
  //               // border: Border.all(
  //               //   color: Colors.black26,
  //               // ),
  //               // color: Colors.redAccent,
  //               ),

  //       buttonElevation: 5,
  //       itemHeight: 40,
  //       itemPadding: const EdgeInsets.only(left: 14, right: 14),
  //       dropdownMaxHeight: 200,
  //       // dropdownWidth: double.infinity,
  //       dropdownPadding: null,
  //       dropdownDecoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(14),
  //         // color: Colors.redAccent,
  //       ),
  //       // drop: 8,
  //       // scrollbarRadius: const Radius.circular(40),
  //       // scrollbarThickness: 6,
  //       // scrollbarAlwaysShow: true,

  //       // offset: const Offset(-20, 0),
  //     ),
  //   );
  // }

  // DropdownButtonHideUnderline addHospitalDropDown(List<Hospital> itemsList,
  //     String placeholder, Function(Hospital) onSelect) {
  //   return DropdownButtonHideUnderline(
  //     child: DropdownButton2(
  //       key: new Key('$x++'),
  //       isExpanded: true,
  //       hint: Row(
  //         children: [
  //           // Icon(
  //           //   Icons.list,
  //           //   size: 16,
  //           //   color: Colors.yellow,
  //           // ),
  //           SizedBox(
  //             width: 4,
  //           ),
  //           Expanded(
  //             child: Text(
  //               placeholder,
  //               textAlign: TextAlign.center,
  //               style: TextStyle(
  //                 fontSize: 14,

  //                 // fontWeight: FontWeight.bold,
  //                 // color: Colors.yellow,
  //               ),
  //               overflow: TextOverflow.ellipsis,
  //             ),
  //           ),
  //         ],
  //       ),
  //       items: itemsList
  //           .map((item) => DropdownMenuItem<String>(
  //                 value: item.name,
  //                 // alignment: Alignment.centerRight,
  //                 child: Text(
  //                   item.name,
  //                   // textAlign: TextAlign.right,
  //                   style: const TextStyle(
  //                     fontSize: 14,
  //                     // fontWeight: FontWeight.bold,
  //                     color: Colors.black,
  //                   ),
  //                   overflow: TextOverflow.ellipsis,
  //                 ),
  //               ))
  //           .toList(),
  //       value: hospital,
  //       onChanged: (value) {
  //         onSelect(longItems
  //             .where((element) => element.name == value as String)
  //             .first);
  //         setState(() {
  //           hospital = value as String;
  //         });
  //       },
  //       // icon: const Icon(
  //       //   Icons.arrow_forward_ios_outlined,
  //       // ),

  //       alignment: AlignmentDirectional.center,
  //       // style: TextStyle(

  //       // ),
  //       iconSize: 20,
  //       iconEnabledColor: primaryColor,
  //       iconDisabledColor: Colors.grey,
  //       buttonHeight: 50,
  //       buttonWidth: double.infinity,
  //       buttonPadding: const EdgeInsets.only(left: 14, right: 14),
  //       buttonDecoration:
  //           BoxDecoration(borderRadius: BorderRadius.circular(25), boxShadow: [
  //         BoxShadow(
  //             offset: Offset.zero,
  //             spreadRadius: 0.1,
  //             blurRadius: 12,
  //             color: Colors.black12)
  //       ]
  //               // border: Border.all(
  //               //   color: Colors.black26,
  //               // ),
  //               // color: Colors.redAccent,
  //               ),

  //       buttonElevation: 5,
  //       itemHeight: 40,
  //       itemPadding: const EdgeInsets.only(left: 14, right: 14),
  //       dropdownMaxHeight: 200,
  //       // dropdownWidth: double.infinity,
  //       dropdownPadding: null,
  //       dropdownDecoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(14),
  //         // color: Colors.redAccent,
  //       ),
  //       // drop: 8,
  //       // scrollbarRadius: const Radius.circular(40),
  //       // scrollbarThickness: 6,
  //       // scrollbarAlwaysShow: true,

  //       // offset: const Offset(-20, 0),
  //     ),
  //   );
  // }
}

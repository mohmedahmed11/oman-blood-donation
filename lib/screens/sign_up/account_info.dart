import 'dart:convert';

import 'package:blood_donation/screens/home/home_screen.dart';
import 'package:blood_donation/widgeds/blood_type.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constant.dart';
import 'component/text_field_container.dart';

class RegisterAccountInfo extends StatefulWidget {
  RegisterAccountInfo({Key? key}) : super(key: key);

  @override
  _RegisterAccountInfoState createState() => _RegisterAccountInfoState();
}

class _RegisterAccountInfoState extends State<RegisterAccountInfo> {
  int _selectedBloodTypeIndex = -1;
  late bool _isMaleSelected;
  late bool _isFemaleSelected;
  TextEditingController ageController = TextEditingController();
  late String age;
  late String gender = "";

  List<String> bloodTypes = ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"];

  late String selectedBloodType = "";

  @override
  void initState() {
    super.initState();
    _selectedBloodTypeIndex = -1;
    _isMaleSelected = false;
    _isFemaleSelected = false;
  }

  final formKey = new GlobalKey<FormState>();

  validate() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      if (_selectedBloodTypeIndex != -1) {
        selectedBloodType = bloodTypes[_selectedBloodTypeIndex];
      }

      _postData();
    } else {}
  }

  _postData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Loading(context);

    var client = http.Client();

    try {
      print(prefs.getInt("user_id").toString());
      var url = Uri.http(baseUrl, '$baseUrlWrite/update.php');
      var uriResponse = await client.post(
        url,
        // headers: headers,
        body: {
          'user_id': prefs.getInt("user_id").toString(),
          'blood_type': selectedBloodType,
          'gender': gender,
          'age': age,
        },
      );

      print(uriResponse.body);
      Navigator.pop(context);
      if (uriResponse.statusCode == 200) {
        var response = jsonDecode(uriResponse.body);
        if (response["status"] as bool == true) {
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return HomeScreen();
          }), ModalRoute.withName('/home'));
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
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: new AssetImage("images/background.png"),
                fit: BoxFit.fill),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Positioned(
                  //   left: 0,
                  //   bottom: -10,
                  //   child: Image.asset(
                  //     "images/bottom-path.png",
                  //     fit: BoxFit.cover,
                  //   ),
                  // ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 60,
                    child: Text(
                      "بيانات الحساب",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: 22,
                          color: secoundColor,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "إختر فصيلة الدم",
                      textAlign: TextAlign.right,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                  ),
                  SizedBox(
                    // color: primaryColor,
                    height: 200,
                    width: double.infinity,
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
                      },
                    ),
                  ),
                  // SizedBox(
                  //   height: 50,
                  // ),
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "النوع",
                      textAlign: TextAlign.right,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    width: 200, //double.infinity,
                    child: Row(
                      textDirection: TextDirection.rtl,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        genderOption(
                          isGenderSelected: _isMaleSelected,
                          press: () {
                            setState(() {
                              _isMaleSelected = true;
                              _isFemaleSelected = false;
                            });
                            gender = "ذكر";
                            print("test");
                          },
                          title: 'ذكر',
                        ),
                        genderOption(
                          isGenderSelected: _isFemaleSelected,
                          press: () {
                            setState(() {
                              _isMaleSelected = false;
                              _isFemaleSelected = true;
                            });
                            gender = "انثى";
                          },
                          title: 'انثى',
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "العمر",
                      textAlign: TextAlign.right,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                  ),
                  Form(
                    key: formKey,
                    child: textFeildContainer(
                      isPassword: false,
                      textcontroller: ageController,
                      type: TextInputType.number,
                      placeholder: 'العمر',
                      onSave: (val) {
                        age = val;
                      },
                      isRequire: false,
                    ),
                  ),

                  SizedBox(
                    height: 20,
                  ),
                  // SizedBox(
                  //   height: 50,
                  //   width: double.infinity,
                  Row(
                    textDirection: TextDirection.rtl,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          validate();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(top: 30.0),
                          height: 50,
                          width: size.width * 0.4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: secoundColor, width: 1.5),
                            // color: Colors.orange
                            color: secoundColor,
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset.zero,
                                  spreadRadius: 0.3,
                                  blurRadius: 3,
                                  color: Colors.black)
                            ],
                          ),
                          child: Text(
                            "حفظ",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) {
                            return HomeScreen();
                          }), ModalRoute.withName('/home'));
                        },
                        child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(top: 30.0),
                          height: 50,
                          width: size.width * 0.4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: primaryColor, width: 1.5),
                            // color: Colors.orange
                            color: primaryColor,
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset.zero,
                                  spreadRadius: 0.3,
                                  blurRadius: 3,
                                  color: Colors.black)
                            ],
                          ),
                          child: Text(
                            "تخطي",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class genderOption extends StatelessWidget {
  const genderOption({
    Key? key,
    required this.isGenderSelected,
    required this.title,
    required this.press,
  }) : super(key: key);

  final bool isGenderSelected;
  final String title;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        // color: Colors.amber,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: isGenderSelected ? primaryColor : Colors.white,
            boxShadow: [
              BoxShadow(
                  offset: Offset.zero,
                  spreadRadius: 0.1,
                  blurRadius: 12,
                  color: Colors.black12)
            ]),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
                color: isGenderSelected ? Colors.white : primaryColor,
                fontSize: 18,
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';

import 'package:blood_donation/constant.dart';
import 'package:blood_donation/screens/home/component.dart/models.dart';
import 'package:blood_donation/screens/sign_up/account_info.dart';
import 'package:blood_donation/screens/sign_up/component/actions_container.dart';
import 'package:blood_donation/screens/sign_up/component/text_field_container.dart';
import 'package:blood_donation/widgeds/blood_type.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UpdateAccount extends StatefulWidget {
  UpdateAccount({Key? key, required this.userData}) : super(key: key);

  final User userData;

  @override
  State<UpdateAccount> createState() => _UpdateAccountState();
}

class _UpdateAccountState extends State<UpdateAccount> {
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  int _selectedBloodTypeIndex = -1;
  late bool _isMaleSelected;
  late bool _isFemaleSelected;
  TextEditingController ageController = TextEditingController();
  late String age = "";
  late String gender = "";

  late String name;
  late String address;
  late String email;
  late String phone;
  late String password;
  int curUserId = 1;

  List<String> bloodTypes = ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"];

  final formKey = new GlobalKey<FormState>();

  late User user;

  late String selectedBloodType = "";

  @override
  void initState() {
    super.initState();
    user = widget.userData;
    _selectedBloodTypeIndex = -1;
    _isMaleSelected = false;
    _isFemaleSelected = false;
    _setData();
  }

  _setData() {
    setState(() {
      nameController.text = user.name;
      name = user.name;
      addressController.text = user.address;
      address = user.address;
      phoneController.text = user.phone;
      emailController.text = user.email ?? '';
      email = user.email ?? '';
      passwordController.text = user.password;
      password = user.password;
      ageController.text = user.age ?? '';
      age = user.age ?? '';
    });

    if (user.bloodType != null) {
      selectedBloodType = user.bloodType ?? '';
      for (var i = 0; i < bloodTypes.length; i++) {
        if (bloodTypes[i] == user.bloodType!) {
          setState(() {
            _selectedBloodTypeIndex = i;
          });
          print("object" + i.toString());
        }
      }
    }

    if (user.gender != null) {
      gender = user.gender ?? '';
      if (user.gender == "ذكر") {}
      setState(() {
        _isMaleSelected = true;
        _isFemaleSelected = false;
      });
    } else {
      setState(() {
        _isMaleSelected = false;
        _isFemaleSelected = true;
      });
    }
  }

  validate() {
    if (nameController.text.isEmpty) {
      _showAlert("لايمكن ترك حقل الإسم فارغ");
      return;
    }

    if (addressController.text.isEmpty) {
      _showAlert("لايمكن ترك حقل العنوان فارغ");
      return;
    }

    if (addressController.text.isEmpty) {
      _showAlert("لايمكن ترك حقل كلمة المرور فارغ");
      return;
    }

    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      _postData();
    } else {}
  }

  _showAlert(String message) {
    MotionToast.error(
            title: Text("عزراً",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                )),
            layoutOrientation: ORIENTATION.rtl,
            description: Text(message))
        .show(context);
  }

  _postData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Loading(context);

    var client = http.Client();

    try {
      var url = Uri.http(baseUrl, '$baseUrlWrite/update_acount.php');
      var uriResponse = await client.post(
        url,
        // headers: headers,
        body: {
          'name': name,
          'address': address,
          'email': email,
          'user_id': prefs.getInt("user_id").toString(),
          'blood_type': selectedBloodType,
          'gender': gender,
          'age': age,
          'password': password,
          'action': 'info'
        },
      );

      Navigator.pop(context);
      if (uriResponse.statusCode == 200) {
        var response = jsonDecode(uriResponse.body);
        if (response["status"] as bool == true) {
          print(response["user_id"] as int);

          Navigator.pop(context); //.pop(context);
          // Navigator.of(context).popAndPushNamed("/homes");
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
        child: SingleChildScrollView(
          child: Column(
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
                      "تعديل بيانات الحساب",
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
              Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      textFeildContainer(
                        isPassword: false,
                        textcontroller: nameController,
                        type: TextInputType.text,
                        placeholder: 'الإسم',
                        onSave: (val) {
                          name = val;
                          nameController.text = val;
                        },
                        isRequire: true,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      textFeildContainer(
                        isPassword: false,
                        textcontroller: addressController,
                        type: TextInputType.text,
                        placeholder: 'العنوان',
                        onSave: (val) {
                          address = val;
                        },
                        isRequire: true,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      textFeildContainer(
                        isPassword: false,
                        textcontroller: emailController,
                        type: TextInputType.emailAddress,
                        placeholder: 'البريد الإلكتروني (إختياري)',
                        onSave: (val) {
                          email = val;
                        },
                        isRequire: false,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      textFeildContainer(
                        isPassword: false,
                        textcontroller: phoneController,
                        type: TextInputType.phone,
                        placeholder: 'رقم الهاتف',
                        onSave: (val) {
                          phone = val;
                        },
                        enabeld: false,
                        isRequire: true,
                      ),

                      SizedBox(
                        height: 20,
                      ),
                      textFeildContainer(
                        isPassword: true,
                        textcontroller: passwordController,
                        type: TextInputType.visiblePassword,
                        placeholder: 'كلمة المرور',
                        onSave: (val) {
                          password = val;
                        },
                        isRequire: true,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "فصيلة الدم",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w800),
                        ),
                      ),
                      SizedBox(
                        // color: primaryColor,
                        height: 200,
                        width: double.infinity,
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
                                  selectedBloodType = bloodTypes[index];
                                });
                              },
                              isSelected: _selectedBloodTypeIndex == index
                                  ? true
                                  : false,
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
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w800),
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
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w800),
                        ),
                      ),
                      textFeildContainer(
                        isPassword: false,
                        textcontroller: ageController,
                        type: TextInputType.number,
                        placeholder: 'العمر',
                        onSave: (val) {
                          age = val;
                        },
                        isRequire: false,
                      ),

                      SizedBox(
                        height: 20,
                      ),

                      actionsContainer(
                        titleText: 'حفظ التعديل',
                        background: primaryColor,
                        textColor: Colors.white,
                        press: () {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          validate();
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (BuildContext context) {
                          //     return RegisterAccountInfo();
                          //   }),
                          // );
                        },
                      ),
                      SizedBox(
                        height: 30,
                      ),

                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //   children: <Widget>[
                    ],
                  ),
                  //   ],
                  // ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

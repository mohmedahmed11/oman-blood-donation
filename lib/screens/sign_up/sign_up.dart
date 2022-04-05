import 'dart:convert';

import 'package:blood_donation/constant.dart';
import 'package:blood_donation/screens/sign_up/account_info.dart';
// import 'package:blood_donation/screens/sign_up/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
// import '../home/home_screen.dart';
import 'component/actions_container.dart';
import 'component/text_field_container.dart';

class SignUp extends StatefulWidget {
  SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  late String name;
  late String address;
  late String email;
  late String phone;
  late String password;
  int curUserId = 1;

  final formKey = new GlobalKey<FormState>();

  validate() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      _postData();
    } else {}
  }

  _postData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Loading(context);

    var client = http.Client();

    try {
      var url = Uri.http(baseUrl, '$baseUrlWrite/register.php');
      var uriResponse = await client.post(
        url,
        // headers: headers,
        body: {
          'name': name,
          'address': address,
          'email': email,
          'phone': phone,
          'password': password,
        },
      );
      Navigator.pop(context);
      if (uriResponse.statusCode == 200) {
        var response = jsonDecode(uriResponse.body);
        if (response["status"] as bool == true) {
          print(response["user_id"] as int);

          await prefs.setBool("isLoggedIn", true);
          await prefs.setInt("user_id", response["user_id"] as int);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (BuildContext context) {
              return RegisterAccountInfo();
            }),
          );
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
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: size.height,
          width: double.infinity,
          // color: Colors.amber,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: Image.asset(
                  "images/background.png",
                  fit: BoxFit.fill,
                ),
              ),
              // Positioned(
              //   left: 0,
              //   bottom: -10,
              //   child: Image.asset(
              //     "images/bottom-path.png",
              //     fit: BoxFit.cover,
              //   ),
              // ),
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 80,
                    ),
                    Image.asset(
                      "images/obb.png",
                      width: 200,
                      height: 100,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text("قطرة دم تساوي حياة",
                        style: TextStyle(
                            color: primaryColor,
                            fontSize: 18,
                            fontFamily: Theme.of(context)
                                .primaryTextTheme
                                .bodyText1!
                                .fontFamily, //.(context),
                            fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 40,
                    ),
                    Form(
                      key: formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Column(
                          children: [
                            textFeildContainer(
                              isPassword: false,
                              textcontroller: nameController,
                              type: TextInputType.text,
                              placeholder: 'الإسم',
                              onSave: (val) {
                                name = val;
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

                            actionsContainer(
                              titleText: 'إنشاء حساب',
                              background: primaryColor,
                              textColor: Colors.white,
                              press: () {
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
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
            ],
          ),
        ),
      ),
    );
  }

  // Container TextFieldContainer() {
  //   return Container(child: );
  // }
}

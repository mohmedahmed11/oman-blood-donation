// import 'dart:html';

import 'dart:convert';

import 'package:blood_donation/screens/sign_up/sign_up.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../constant.dart';
import '../home/home_screen.dart';
import 'component/actions_container.dart';
import 'component/text_field_container.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController statementController = TextEditingController();
  TextEditingController totalController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

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
    // final overlay = LoadingOverlay.of(context);
    Loading(context);

    var client = http.Client();

    try {
      var url = Uri.http(baseUrl, '$baseUrlWrite/login.php');
      var uriResponse = await client.post(
        url,
        // headers: ,
        body: {'phone': phone, 'password': password},
      );

      print(uriResponse.body);
      Navigator.pop(context);
      if (uriResponse.statusCode == 200) {
        var response = jsonDecode(uriResponse.body);
        if (response["status"] as bool == true) {
          await prefs.setBool("isLoggedIn", true);
          await prefs.setInt("user_id", response["user_id"] as int);
          Navigator.of(context).popAndPushNamed("/homes");
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

  DateTime pre_backpress = DateTime.now();

  @override
  Widget build(BuildContext context) {
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
      child: SafeArea(
        child: Scaffold(
          body: Container(
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
                    // Expanded(child: child)
                    // // SizedBox(
                    // //   height: 50,
                    // // ),
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
                            fontSize: 16,
                            fontFamily: Theme.of(context)
                                .primaryTextTheme
                                .bodyText1!
                                .fontFamily, //.(context),
                            fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 50,
                    ),
                    Form(
                      key: formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Column(
                          children: [
                            textFeildContainer(
                                isPassword: false,
                                textcontroller: phoneController,
                                type: TextInputType.phone,
                                placeholder: 'رقم الهاتف',
                                onSave: (val) {
                                  phone = val;
                                }),
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
                                }),
                            SizedBox(
                              height: 20,
                            ),
                            actionsContainer(
                              titleText: 'تسجيل دخول',
                              background: primaryColor,
                              textColor: Colors.white,
                              press: () {
                                print("d");
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                                validate();
                              },
                            ),
                            actionsContainer(
                              titleText: 'إنشاء حساب',
                              background: Colors.white,
                              textColor: primaryColor,
                              press: () {
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) {
                                    return SignUp();
                                  }),
                                );
                              },
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            GestureDetector(
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                                Navigator.pushAndRemoveUntil(context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) {
                                  return HomeScreen();
                                }), ModalRoute.withName('/homes'));
                              },
                              child: Container(
                                child: Text("تخطي ؟",
                                    style: TextStyle(
                                        color: secoundColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            )
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
          ),
        ),
      ),
    );
  }

  // Container TextFieldContainer() {
  //   return Container(child: );
  // }
}

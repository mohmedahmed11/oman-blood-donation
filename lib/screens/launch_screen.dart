// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home/home_screen.dart';
import 'login/login_page.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({Key? key}) : super(key: key);
  @override
  _LaunchScreenState createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  _startTimer() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Timer(
        Duration(seconds: 3),
        () => {
              if (prefs.getBool('isLoggedIn') == null)
                {
                  // Navigator.pushAndRemoveUntil(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => LoginPage()),
                  //   (Route<dynamic> route) => false,
                  // )
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginPage()))
                }
              else if (prefs.getBool('isLoggedIn') == true)
                {
                  // Navigator.pushAndRemoveUntil(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => HomeScreen()),
                  //   (Route<dynamic> route) => false,
                  // )
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              HomeScreen())) //return HomeScreen();
                }
              else
                {
                  // Navigator.pushAndRemoveUntil(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => LoginPage()),
                  //   (Route<dynamic> route) => false,
                  // )
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginPage()))
                }
              // Navigator.pushNamed(context, routeName)
              //     Navigator.pushReplacement(
              //       context,
              //       MaterialPageRoute(builder: (BuildContext context) {
              //         // var isLoggedIn = false
              //         prefs.setBool("isLoggedIn", false);
              //         print(prefs.getBool('isLoggedIn'));

              //       }),
              // ),
            });
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Center(
              child: Image.asset(
            "images/backgroud.jpeg",
            width: size.width,
            height: size.height,
            fit: BoxFit.fill,
          )),
        ),
      ),
    );
  }
}

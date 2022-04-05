import 'dart:io';

import 'package:blood_donation/constant.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUs extends StatefulWidget {
  ContactUs({Key? key}) : super(key: key);

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  _makeCall() async {
    var url = 'tel:0096897788305';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _openMAil() async {
    var url = 'mailto:oman.bb2040@gmail.com';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchWhatsapp() async {
    var whatsapp = "+96897788305";
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

  _launchweb() async {
    var url = 'http://blood-donation.asasroad.com';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    'تواصل معنا',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w700),
                  )
                ],
              ),
            ),
            // SizedBox(height: 20),
            Image.asset("images/obb-1.png"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "للإستفسار:",
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                textDirection: TextDirection.rtl,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      "0096897788305",
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  IconButton(
                      onPressed: _makeCall,
                      iconSize: 30,
                      icon: Icon(Icons.call_rounded),
                      color: primaryColor),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                textDirection: TextDirection.rtl,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      "0096897788305",
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  IconButton(
                      onPressed: _launchWhatsapp,
                      iconSize: 30,
                      icon: Image.asset(
                        "images/whatsapp.png",
                        width: 25,
                        height: 25,
                      ),
                      color: primaryColor),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                textDirection: TextDirection.rtl,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      "oman.bb2040@gmail.com",
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  IconButton(
                      onPressed: _openMAil,
                      iconSize: 30,
                      icon: Icon(Icons.mail),
                      color: primaryColor),
                  // IconButton(
                  //     onPressed: () {},
                  //     iconSize: 30,
                  //     icon: Image.asset(
                  //       "images/whatsapp.png",
                  //       width: 25,
                  //       height: 25,
                  //     ),
                  //     color: primaryColor),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                textDirection: TextDirection.rtl,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      "blood-donation.asasroad.com",
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  IconButton(
                      onPressed: _launchweb,
                      iconSize: 30,
                      icon: Icon(Icons.language),
                      color: primaryColor),
                ],
              ),
            ),
            Expanded(
              child: Container(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                textDirection: TextDirection.rtl,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      "جميع الحقوق محفوظة لدى تطبيق بنك الدم العماني",
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

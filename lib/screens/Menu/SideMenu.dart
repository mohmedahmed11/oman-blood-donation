import 'package:blood_donation/screens/Menu/donating_list.dart';
import 'package:blood_donation/screens/Menu/profile.dart';
import 'package:blood_donation/screens/Menu/request_list.dart';
import 'package:blood_donation/screens/home/about.dart';
import 'package:blood_donation/screens/home/contact_us.dart';
import 'package:blood_donation/screens/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({Key? key, required this.openNewPage}) : super(key: key);
  final VoidCallback openNewPage;
  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  late bool isLogedIn = false;
  late VoidCallback _onOpenNewPage;
  @override
  void initState() {
    super.initState();
    _onOpenNewPage = widget.openNewPage;
    _checkisLogedIn();
  }

  _checkisLogedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('isLoggedIn') != null &&
        prefs.getBool('isLoggedIn') == true) {
      setState(() {
        isLogedIn = true;
      });
    }
  }

  _launchweb() async {
    var url = 'http://blood-donation.asasroad.com/privacy.html';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> share() async {
    await FlutterShare.share(
        title: 'بنك الدم العماني',
        text: 'التطبيق الاول في عمان',
        linkUrl:
            'https://play.google.com/store/apps/details?id=com.pitastudio.blood_donation',
        chooserTitle: 'بنك الدم العماني');
  }

  @override
  Widget build(BuildContext context) {
    _checkisLogedIn();
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
                // color: Colors.blue,
                ),
            child: Image.asset(
              "images/obb.png",
              // fit: BoxFit.none,
              // width: 200,
              // height: 100,
            ), //Text('Drawer Header'),
          ),
          ListTile(
            title: Row(
              textDirection: TextDirection.rtl,
              children: [
                Icon(
                  Icons.person,
                  size: 34,
                ),
                SizedBox(width: 5),
                Text(isLogedIn ? "حسابي" : "تسجيل دخول")
              ],
            ),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              if (isLogedIn) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  widget.openNewPage();
                  return Profile();
                })).then((value) => widget.openNewPage());
              } else {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return LoginPage();
                }));
              }
            },
          ),
          isLogedIn
              ? ListTile(
                  title: Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Icon(
                        Icons.search,
                        size: 34,
                      ),
                      SizedBox(width: 5),
                      Text('الطلبات البحث')
                    ],
                  ),
                  onTap: () {
                    // Update the state of the app
                    // ...
                    if (isLogedIn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return RequestList();
                      })).then((value) => widget.openNewPage());
                    }
                    // Then close the drawer
                    // Navigator.pop(context);
                  },
                )
              : Container(),
          isLogedIn
              ? ListTile(
                  title: Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Icon(
                        Icons.content_paste_search,
                        size: 34,
                      ),
                      SizedBox(width: 5),
                      Text('الطلبات الواردة')
                    ],
                  ),
                  onTap: () {
                    // Update the state of the app
                    // ...
                    if (isLogedIn) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return DonatingList();
                      })).then((value) => widget.openNewPage());
                    }
                    // Then close the drawer
                    // Navigator.pop(context);
                  },
                )
              : Container(),
          ListTile(
            title: Row(
              textDirection: TextDirection.rtl,
              children: [
                Icon(
                  Icons.info_rounded,
                  size: 34,
                ),
                SizedBox(width: 5),
                Text('عن التطبيق')
              ],
            ),
            onTap: () {
              // Update the state of the app
              // ...
              _onOpenNewPage();
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return AboutApp();
              })).then((value) => widget.openNewPage());
              // Then close the drawer
              // Navigator.pop(context);
            },
          ),
          ListTile(
            title: Row(
              textDirection: TextDirection.rtl,
              children: [
                Icon(
                  Icons.call,
                  size: 34,
                ),
                SizedBox(width: 5),
                Text('تواصل معنا')
              ],
            ),
            onTap: () {
              // Update the state of the app
              // ...
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return ContactUs();
              })).then((value) => widget.openNewPage());
              // Then close the drawer
              // Navigator.pop(context);
            },
          ),
          ListTile(
            title: Row(
              textDirection: TextDirection.rtl,
              children: [
                Icon(
                  Icons.share,
                  size: 34,
                ),
                SizedBox(width: 5),
                Text('مشاركة التطبيق')
              ],
            ),
            onTap: () {
              // Update the state of the app
              // ...
              share();
              // Then close the drawer
              // Navigator.pop(context);
            },
          ),
          ListTile(
            title: Row(
              textDirection: TextDirection.rtl,
              children: [
                Icon(
                  Icons.contact_support,
                  size: 34,
                ),
                SizedBox(width: 5),
                Text('الشروط والاحكام')
              ],
            ),
            onTap: () {
              // Update the state of the app
              // ...
              _launchweb();
              widget.openNewPage();
              // Then close the drawer
              // Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text(''),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              widget.openNewPage();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

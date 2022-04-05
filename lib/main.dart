import 'package:blood_donation/pushnotification.dart';
// import 'package:blood_donation/pushnotification.dart';
import 'package:blood_donation/screens/home/home_screen.dart';
import 'package:blood_donation/screens/launch_screen.dart';
import 'package:blood_donation/screens/login/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

// import 'native';

import 'constant.dart';
import 'screens/home/Search_For_donater.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification!.title);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  LocalNotificationService.initialize();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLogin = false;
  // static final FirebaseMessaging messaging = FirebaseMessaging.instance;

  @override
  Widget build(BuildContext context) {
    // final pushNotificationService = PushNotificationService(messaging);
    // pushNotificationService.initialise();
    return MaterialApp(
      title: 'Blood Donation',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          // primarySwatch: MaterialColor(primaryColor.) ,
          primaryColor: primaryColor,
          fontFamily: "tajawal"),
      initialRoute: '/home',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/home': (context) => const LaunchScreen(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/homes': (context) => const HomeScreen(),
        '/search': (context) => SearchForDonater(),
        '/login': (context) => LoginPage()
      },
      home: isLogin ? const HomeScreen() : const LaunchScreen(),
    );
  }
}

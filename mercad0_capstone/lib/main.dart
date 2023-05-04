import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mercad0_capstone/Auth/Login.dart';
import 'package:mercad0_capstone/Auth/ProfilePage.dart';
import 'package:mercad0_capstone/Farmer%20Screens/farmer_screen.dart';
import 'package:mercad0_capstone/Organization%20Screens/organization_screen.dart';
import 'Controller/cart_controller.dart';
import 'Screens/home_screen.dart';
import 'Auth/AuthPage.dart';
import 'package:splashscreen/splashscreen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(CartController());
  runApp(GetMaterialApp(home: MyApp()));
}

final navigatorKey = GlobalKey<NavigatorState>();
final messengerKey = GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  static const String _title = 'MERCADO';

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 3,
      image: Image.asset('lib/Assets/Mercado_Icon.png'),
      navigateAfterSeconds: Entry(),
      photoSize: 100.0,
      backgroundColor: Colors.white,
      styleTextUnderTheLoader: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      loaderColor: Colors.green,
    );
  }
}

class Entry extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: messengerKey,
      navigatorKey: navigatorKey,
      title: MyApp._title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Mainpage(),
    );
  }
}

class Mainpage extends StatefulWidget {
  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Something went wrong'));
                } else if (snapshot.data != null)
                // Check if user is logged out
                if (snapshot.connectionState == ConnectionState.done) {
                  return Login(
                    onClickedSignUp: () {},
                  );
                }
                return Login(
                  onClickedSignUp: () {},
                );
              }),
        ),
      );
}

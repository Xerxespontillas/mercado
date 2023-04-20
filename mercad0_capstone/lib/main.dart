import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                } else if (snapshot.data != null) {
                  return StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("users")
                          .doc(snapshot.data!.uid)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.hasData) {
                          final user =
                              snapshot.data?.data() as Map<String, dynamic>;
                          if (user["role"] == 'customer') {
                            return HomeScreen();
                          } else if (user['role'] == 'farmer') {
                            return Farmers();
                          } else if (user['role'] == 'organization') {
                            return Organization();
                          } else
                            return ProfilePage();
                        } else {
                          return AlertDialog(
                            title: Text('Not authenticated'),
                            content: Text('Please log in to access the app'),
                            actions: [
                              TextButton(
                                child: Text('OK'),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          );
                        }
                      });
                } else {
                  // Redirect user to AuthPage
                  return AuthPage();
                }
              }),
        ),
      );
}

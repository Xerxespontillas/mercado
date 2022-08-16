import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Screens/home_screen.dart';
import'Auth/AuthPage.dart';
import 'package:splashscreen/splashscreen.dart';
Future main() async{
 WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  runApp(GetMaterialApp(home: MyApp())); 
}
final navigatorKey= GlobalKey<NavigatorState>();
 final messengerKey= GlobalKey<ScaffoldMessengerState>();

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
    Timer(Duration(seconds: 3),  
            ()=>Get.to(Entry()) 
    );  
  }  
  @override  
  Widget build(BuildContext context) {  
    return SplashScreen(
        seconds: 8,
         image: Image.asset('lib/Assets/Mercado_Icon.png'),
        photoSize: 100.0,        
        backgroundColor: Colors.white,
        styleTextUnderTheLoader: new TextStyle(),
        loaderColor: Colors.green
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
      home:Mainpage(),
    );
  }
}


  class Mainpage extends StatelessWidget{
    @override
    Widget build(BuildContext context)=> Scaffold(
body: SafeArea(
  child:   StreamBuilder<User?>(
  
    stream: FirebaseAuth.instance.authStateChanges(),
  
    builder:(context, snapshot) {
  
      if(snapshot.connectionState == ConnectionState.waiting)
      {
  
        return Center(child: CircularProgressIndicator());
      }
      else if (snapshot.hasError){
        return Center(child: Text('Something went wrong'));
  
      }
      else if(snapshot.hasData){
     return HomeScreen();
      }
      else {
  
        return AuthPage();
  
      }
  }
  ),
)
);

}
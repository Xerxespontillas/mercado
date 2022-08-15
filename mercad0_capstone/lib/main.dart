import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import'Auth/AuthPage.dart';
import 'Screens/home_screen.dart';
import 'package:get/get.dart';

Future main() async{
 WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  runApp(GetMaterialApp(home: MyApp())); 
}
final navigatorKey= GlobalKey<NavigatorState>();
 final messengerKey= GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static const String _title = 'MERCADO';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: messengerKey,
      navigatorKey: navigatorKey,
      title: _title,
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
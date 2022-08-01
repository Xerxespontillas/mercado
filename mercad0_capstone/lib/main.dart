
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Login.dart';
import 'Login.dart';
import 'HomePage.dart';
Future main() async{
 WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static const String _title = 'MERCADO';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
body: StreamBuilder<User?>(
  stream: FirebaseAuth.instance.authStateChanges(),
  builder:(context, snapshot) {
    if(snapshot.hasData){
   return HomePage();
    }
    else{
      return Login();
    }
  
}
)
);

}
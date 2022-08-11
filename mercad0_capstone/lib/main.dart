import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'HomePage.dart';
import'AuthPage.dart';
import 'Utilities/Utils.dart';
Future main() async{
 WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  runApp(const MyApp());
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
body: StreamBuilder<User?>(
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
   return HomePage();
    }
    else {
      return AuthPage();
    }
  
}
)
);

}
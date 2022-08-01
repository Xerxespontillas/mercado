import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final user= FirebaseAuth.instance.currentUser!;
   return  Scaffold(
        appBar: AppBar(
          title: Text('Mercado'),
        ),
        body: Padding(padding: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Signed In as:',style: TextStyle(fontSize: 16),),
            SizedBox(height: 8),
            Text(user.email!),
          ],
        ),),
        );
  }


}
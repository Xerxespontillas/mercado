import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final user= FirebaseAuth.instance.currentUser!;
   return  Scaffold(
        appBar: AppBar(
          title: Text('Basket'),
        ),
        body: Padding(padding: EdgeInsets.all(32),
       ), 
        );
  }


}
import 'package:flutter/material.dart';
import '../Widgets/cart_products.dart';
import 'package:mercad0_capstone/Widgets/cart_total.dart';
class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

   return  Scaffold(
        appBar: AppBar(
          title: Text('Basket'),
        ),
        body: ListView(
          children: [
            CartProducts(),
            CartTotal(),
            SizedBox(height: 20,)
            
          ],
        )
       );
  }


}
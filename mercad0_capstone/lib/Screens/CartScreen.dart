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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CartProducts(),
            CartTotal(),
             SizedBox(height: 30,),
          ],
        )
       );
  }


}
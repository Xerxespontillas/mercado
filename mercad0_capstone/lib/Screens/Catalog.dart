import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mercad0_capstone/Widgets/CatalogProducts.dart';
import 'package:mercad0_capstone/Screens/CartScreen.dart';
class CatalogScreen extends StatelessWidget {
  const CatalogScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("MERCADO"),actions: [
IconButton(onPressed: 

() => Get.to(()=>CartScreen()) , icon: const Icon(Icons.shopping_cart_checkout),)
    ],),
    body: SafeArea(
      child: 
      Column(children: [
      CatalogProducts(),
    ],)),
    );
  }
}
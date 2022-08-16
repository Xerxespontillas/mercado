import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mercad0_capstone/Controller/cart_controller.dart';
import 'package:mercad0_capstone/Controller/product_controller.dart';
import 'package:get/get.dart';
class CatalogProducts extends StatelessWidget {
  final  productController= Get.put(ProductController());
   CatalogProducts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      ()=> Flexible(child: ListView.builder(
        itemCount: productController.products.length,
        itemBuilder: (BuildContext context, int index){
        return CatalogProductCard(index: index);
      } )),
    );
  }
}
class CatalogProductCard extends StatelessWidget {
  final cartController= Get.put(CartController());
  final ProductController productController=Get.find();
  final int index;
 CatalogProductCard({Key? key,required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      child: Row(children: [
        CircleAvatar(radius:40,backgroundImage: NetworkImage(productController.products[index].imgUrl),
    ),
    SizedBox(width: 40,),
    Expanded(child: Text(productController.products[index].name,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
    Expanded(child:Text('₱${productController.products[index].price}')),
    IconButton(onPressed: () {cartController.addProduct(productController.products[index]);}, icon: Icon(Icons.add_circle))
    ]),
    );
  }
}

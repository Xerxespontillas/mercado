import'package:flutter/material.dart';
import 'package:mercad0_capstone/Controller/cart_controller.dart';
import'package:get/get.dart';
import 'package:mercad0_capstone/Models/product_model.dart';
class CartProducts extends StatelessWidget {
  final CartController controller = Get.find();
   CartProducts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SizedBox(height: 500,child: ListView.builder(
        itemCount: controller.products.length,
      itemBuilder: (BuildContext context, int index) {
       if(controller.products.length == 0) {
       return  Center(
        child: Text('No data'));
       }  
      else {
         return CartProductCard(
      controller: controller,
      product: controller.products.keys.toList()[index],
      quantity: controller.products.values.toList()[index],
      index: index,
    );
      }
      })
      ),
    );
  }
}

class CartProductCard extends StatelessWidget {
  final CartController controller;
  final Product product;
  final int quantity;
  final int index;
  const CartProductCard({Key? key,
  required this.controller,
  required this.product,
  required this.quantity,
    required this. index,
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return product == 0 ? Center(child: Text('Empty')) : Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 5.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(
              product.imgUrl,
            ),
          ),
           SizedBox(width: 15,),
          Expanded(child: Text(product.name)),
          IconButton(onPressed: (){
      controller.removeProduct(product);
         }, icon: Icon(Icons.remove_circle)),
          Text('${quantity}'),
          IconButton(onPressed: (){
           controller.addProduct(product);
         }, icon: Icon(Icons.add_circle)),
        ],
      ),
    );
  }
}
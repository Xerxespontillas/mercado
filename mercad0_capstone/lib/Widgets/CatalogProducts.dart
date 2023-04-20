import 'dart:ui';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mercad0_capstone/Controller/cart_controller.dart';
import 'package:mercad0_capstone/Controller/product_controller.dart';
import 'package:get/get.dart';

class CatalogProducts extends StatelessWidget {
  final productController = Get.put(ProductController());
  CatalogProducts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Flexible(
          child: ListView.builder(
              itemCount: productController.products.length,
              itemBuilder: (BuildContext context, int index) {
                return CatalogProductCard(index: index);
              })),
    );
  }
}

class CatalogProductCard extends StatelessWidget {
  final CartController cartController = Get.find();
  final ProductController productController = Get.find();
  final int index;

  CatalogProductCard({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(children: [
        FutureBuilder(
          future: FirebaseStorage.instance.ref(productController.products[index].imagePath).getDownloadURL(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(snapshot.data.toString()),
              );
            } else {
              return CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey,
              );
            }
          },
        ),
        SizedBox(
          width: 40,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                productController.products[index].name,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                productController.products[index].description ?? '',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 5),
              Text(
                '₱ ${productController.products[index].price}',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            cartController.addProduct(productController.products[index]);
          },
          icon: Icon(Icons.add_circle),
        )
      ]),
    );
  }
}

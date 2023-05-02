import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mercad0_capstone/Controller/cart_controller.dart';
import 'package:mercad0_capstone/Controller/product_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
            return CatalogProductCard(
                index: index,
                productController: productController); // add this line
          },
        ),
      ),
    );
  }
}

class CatalogProductCard extends StatefulWidget {
  final int index;
  final ProductController productController;

  CatalogProductCard(
      {Key? key, required this.index, required this.productController})
      : super(key: key);

  @override
  _CatalogProductCardState createState() => _CatalogProductCardState();
}

class _CatalogProductCardState extends State<CatalogProductCard> {
  final cartController = Get.find<CartController>();

  late String imageUrl;

  @override
  void initState() {
    super.initState();
    imageUrl = '';
    FirebaseStorage.instance
        .ref('images/${widget.productController.products[widget.index].imagePath}')
        .getDownloadURL()
        .then((value) {
      if (value != null) { // check if value is not null
        setState(() {
          imageUrl = value;
        });
      } else {
        print('Error retrieving image from Firebase Storage: download URL is null');
      }
    }).catchError((error) {
      print('Error retrieving image from Firebase Storage: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.productController.products[widget.index];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300],
            ),
            child: imageUrl != '' // check if imageUrl is not empty
                ? CachedNetworkImage(
                    imageUrl: imageUrl,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    fit: BoxFit.cover,
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ), // display loading indicator
          ),
          SizedBox(
            width: 40,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  product.description,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 5),
                Text(
                  '₱ ${product.price}',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {});
              cartController.addProduct(product);
            },
            icon: Icon(Icons.add_circle),
          )
        ],
      ),
    );
  }
}

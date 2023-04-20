import 'package:flutter/material.dart';
import 'package:mercad0_capstone/Controller/cart_controller.dart';
import 'package:get/get.dart';
import 'package:mercad0_capstone/Models/product_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CartProducts extends StatelessWidget {
  final CartController controller = Get.find();
  CartProducts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: controller.products.length == 0
          ? Center(child: Text('Empty'))
          : Obx(() => ListView.builder(
              itemCount: controller.products.length,
              itemBuilder: (BuildContext context, int index) {
                return CartProductCard(
                  controller: controller,
                  product: controller.products.keys.toList()[index],
                  quantity: controller.products.values.toList()[index],
                  index: index,
                );
              })),
    );
  }
}

class CartProductCard extends StatefulWidget {
  final CartController controller;
  final Product product;
  final int quantity;
  final int index;
  const CartProductCard({
    Key? key,
    required this.controller,
    required this.product,
    required this.quantity,
    required this.index,
  }) : super(key: key);

  @override
  _CartProductCardState createState() => _CartProductCardState();
}

class _CartProductCardState extends State<CartProductCard> {
  late final ImageProvider<Object> _imageProvider;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getImage();
  }

  Future<void> _getImage() async {
    final ref = FirebaseStorage.instance.ref().child(widget.product.imagePath);
    final url = await ref.getDownloadURL();
    setState(() {
      _imageProvider = NetworkImage(url);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            child: _isLoading
                ? CircularProgressIndicator()
                : Image(image: _imageProvider),
          ),
          SizedBox(
            width: 15,
          ),
          Expanded(child: Text(widget.product.name)),
          IconButton(
              onPressed: () {
                widget.controller.removeProduct(widget.product);
              },
              icon: Icon(Icons.remove_circle)),
          Text('${widget.quantity}'),
          IconButton(
              onPressed: () {
                widget.controller.addProduct(widget.product);
              },
              icon: Icon(Icons.add_circle)),
        ],
      ),
    );
  }
}

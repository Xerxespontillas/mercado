import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mercad0_capstone/Screens/CartScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:mercad0_capstone/Screens/catalog_screen.dart';

import '../Widgets/CatalogProducts.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({Key? key}) : super(key: key);

  @override
  _CatalogScreenState createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  Future<void> _addProductToFirebase() async {
  try {
    final String imageName = DateTime.now().toString();
    final Reference ref = FirebaseStorage.instance.ref().child('images/$imageName.jpg');
    final UploadTask uploadTask = ref.putFile(File(_imageController.text));
    final TaskSnapshot downloadUrl = (await uploadTask.whenComplete(() => null)!);
    final String url = await downloadUrl.ref.getDownloadURL();

    final DocumentReference docRef =
        FirebaseFirestore.instance.collection('products').doc();

    await docRef.set({
      'name': _nameController.text,
      'description': _descriptionController.text,
      'price': int.parse(_priceController.text),
      'address': _addressController.text,
      'quantity': int.parse(_quantityController.text),
      'imageRef': ref.fullPath, // save the reference to the uploaded image
    });

    Get.snackbar('Success', 'Product added successfully');
  } catch (e) {
    Get.snackbar('Error', e.toString());
    print(e);
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MERCADO"),
        actions: [
          IconButton(
            onPressed: () => {Get.to(() => CartScreen())},
            icon: const Icon(Icons.shopping_cart_checkout),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            CatalogProducts(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final ImagePicker _picker = ImagePicker();
          final XFile? image =
              await _picker.pickImage(source: ImageSource.gallery);
          if (image != null) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Add Product'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Name',
                          ),
                        ),
                        TextField(
                          controller: _descriptionController,
                          decoration: InputDecoration(
                            labelText: 'Description',
                          ),
                        ),
                        TextField(
                          controller: _priceController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Price',
                          ),
                        ),
                        TextField(
                          controller: _addressController,
                          decoration: InputDecoration(
                            labelText: 'Address',
                          ),
                        ),
                        TextField(
                          controller: _quantityController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Quantity',
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          height: 200,
                          width: 200,
                          child: Stack(
                            children: [
                              Center(
                                child: Image.file(
                                  File(image.path),
                                  height: 150,
                                  width: 150,
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: IconButton(
                                  onPressed: () async {
                                    final newImage = await _picker.pickImage(
                                        source: ImageSource.gallery);
                                    if (newImage != null) {
                                      setState(() {
                                        _imageController.text = newImage.path;
                                      });
                                    }
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text('Add'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        _addProductToFirebase();
                      },
                    ),
                  ],
                );
              },
            );
          } else {
            Get.snackbar('Error', 'No image selected');
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

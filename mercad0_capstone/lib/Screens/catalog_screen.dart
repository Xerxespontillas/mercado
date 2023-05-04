import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mercad0_capstone/Screens/CartScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mercad0_capstone/Widgets/CatalogProducts.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({Key? key}) : super(key: key);

  @override
  _CatalogScreenState createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final _picker = ImagePicker();

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _addressController = TextEditingController();
  final _quantityController = TextEditingController();
  File? _image;
  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _addressController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _selectImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
    setState(() {});
  }

<<<<<<< HEAD
  Future<void> _addProductToFirebase() async {
=======
 Future<void> _addProductToFirebase() async {
>>>>>>> 97939cb5d9d661a2235fc986a58da5f2b77ad7b4
    try {
      if (_image == null) {
        Get.snackbar('Error', 'Please select an image');
        return;
      }

      final String imageName = DateTime.now().toString();
      final Reference ref =
          FirebaseStorage.instance.ref().child('images/$imageName');
      final UploadTask uploadTask = ref.putFile(_image!);
      final TaskSnapshot snapshot = await uploadTask;
<<<<<<< HEAD
      final String url = await snapshot.ref.getDownloadURL(); // get image URL
=======
      final String url = await snapshot.ref.getDownloadURL();
>>>>>>> 97939cb5d9d661a2235fc986a58da5f2b77ad7b4

      final DocumentReference docRef =
          FirebaseFirestore.instance.collection('products').doc();

      await docRef.set({
        'name': _nameController.text,
        'description': _descriptionController.text,
        'price': int.tryParse(_priceController.text) ?? 0,
        'address': _addressController.text,
        'quantity': int.tryParse(_quantityController.text) ?? 0,
        'imageRef': url, // Update image reference to URL
      });

      Get.snackbar('Success', 'Product added successfully');
    } catch (e) {
      Get.snackbar('Error', e.toString());
      print(e);
    }
  }

<<<<<<< HEAD
=======

>>>>>>> 97939cb5d9d661a2235fc986a58da5f2b77ad7b4
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
<<<<<<< HEAD
            CatalogProducts(),
=======
              CatalogProducts(),
>>>>>>> 97939cb5d9d661a2235fc986a58da5f2b77ad7b4
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
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
                      if (_image != null)
                        Image.file(
                          _image!,
                          height: 200,
                          width: 200,
                        ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectImage();
                          });
<<<<<<< HEAD
=======
                          
>>>>>>> 97939cb5d9d661a2235fc986a58da5f2b77ad7b4
                        },
                        child: const Text('Select Image'),
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      _addressController.clear();
                      _nameController.clear();
                      _descriptionController.clear();
                      _priceController.clear();
                      _quantityController.clear();
                      setState(() {
                        _image = null;
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text('Add'),
                    onPressed: () async {
                      if (_nameController.text.isEmpty ||
                          _descriptionController.text.isEmpty ||
                          _priceController.text.isEmpty ||
                          _quantityController.text.isEmpty ||
                          _addressController.text.isEmpty) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Error'),
                            content: Text('Please fill all the fields.'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );
                      } else {
                        Navigator.of(context).pop();
                        await _addProductToFirebase();
                      }
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

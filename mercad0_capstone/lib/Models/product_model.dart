import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String id;
  String name;
  String description;
  String address;
  double price;
 late String imagePath;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.price,
    required this.imagePath,
  });

 static Product fromSnapshot(DocumentSnapshot snapshot) {
  Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
  double price = 0.00;
  try {
    price = data['price'].toDouble();
  } catch (e) {
    // Handle the error here
    print('Error parsing price: $e');
  }
  return Product(
    id: snapshot.id,
    name: data['name'],
    description: data['description'],
    address: data['address'],
    price: price,
    imagePath: data['imagePath'],
  );
}

}

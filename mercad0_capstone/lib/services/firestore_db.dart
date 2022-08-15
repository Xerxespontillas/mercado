import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mercad0_capstone/Models/product_model.dart';

class FireStoreDB{
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  Stream<List<Product>> getAllProducts() {
    return _firebaseFirestore.collection('products').snapshots().map((snapshot)
     {return snapshot.docs.map((doc)=>Product.fromSnapshot(doc)).toList();
  });
}
}
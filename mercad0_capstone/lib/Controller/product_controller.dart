import 'package:get/get.dart';
import 'package:mercad0_capstone/services/firestore_db.dart';

import '../Models/product_model.dart';

class ProductController extends GetxController{
  final products = <Product>[].obs;
  @override 
  void onInit(){
    products.bindStream(FireStoreDB().getAllProducts());
    print('passed here!!!!');
    super.onInit();
  }

}
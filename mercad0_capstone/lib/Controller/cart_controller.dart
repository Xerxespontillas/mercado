import 'dart:io';

import 'package:get/get.dart';
import 'package:mercad0_capstone/Models/product_model.dart';

class CartController extends GetxController{
  var _products= {}.obs;
 
 void addProduct(Product product){
  if(_products.containsKey(product)){
    _products[product] +=1;
  }
  else{
    _products[product] =1;
  }
  Get.snackbar("Product Added", "You have added ${product.name} to the cart",
  snackPosition: SnackPosition.TOP,duration: Duration(seconds: 2 ));
 }
 
 //void removeProduct (){}
 //get products
 //get productSubtotal
 //get total


}
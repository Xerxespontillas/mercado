import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';

class Product{
   final String name;
 final double price;
 final String imgUrl;

const Product({required this.name,required this.price,required this.imgUrl});

static Product fromSnapshot(DocumentSnapshot snap){
  Product product = 
  Product(
    imgUrl:snap['imgUrl'] 
  ,name:snap['name'],
  price:snap['price'],);
  return product;
}




// static const List<Product> products=[
//   Product(
//     name: 'Apple',
//     price: 30,
//     imgUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5b/The_SugarBee_Apple_now_grown_in_Washington_State.jpg/270px-The_SugarBee_Apple_now_grown_in_Washington_State.jpg'
//   ),
//    Product(
//     name: 'Mango',
//     price: 50,
//     imgUrl: 'https://fruitsandveggies.org/wp-content/uploads/2007/01/hotchicksing-566652-unsplash-1440x658.jpg'
//   ),
//    Product(
//     name: 'Pineapple',
//     price: 100,
//     imgUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/7/74/%E0%B4%95%E0%B5%88%E0%B4%A4%E0%B4%9A%E0%B5%8D%E0%B4%9A%E0%B4%95%E0%B5%8D%E0%B4%95.jpg/220px-%E0%B4%95%E0%B5%88%E0%B4%A4%E0%B4%9A%E0%B5%8D%E0%B4%9A%E0%B4%95%E0%B5%8D%E0%B4%95.jpg'
//   ),
// ];
}
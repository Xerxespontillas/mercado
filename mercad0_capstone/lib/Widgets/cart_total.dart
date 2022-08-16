import 'package:flutter/material.dart';
import 'package:mercad0_capstone/Controller/cart_controller.dart';
import 'package:get/get.dart';

class CartTotal extends StatelessWidget {
  final CartController controller= Get.find();
 CartTotal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
     ()=> Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total',style: TextStyle( 
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.black
            ),),
            Text('₱${controller.total}',style: TextStyle( 
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.black
            ),)
          ],
        ),
      ),
    );
  }
}
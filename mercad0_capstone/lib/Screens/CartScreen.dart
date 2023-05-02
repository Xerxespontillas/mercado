import 'package:flutter/material.dart';
import '../Widgets/cart_products.dart';
import 'package:mercad0_capstone/Widgets/cart_total.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Basket'),
        centerTitle: true,
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: CartProducts(),
          ),
          Divider(
            height: 2,
            color: Colors.grey[300],
          ),
          CartTotal(),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              print('Bought');
            },
            child: Text(
              'BUY',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

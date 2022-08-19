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
      ),
      body: ListView(
        children: [
          Column(
            children: [
              CartProducts(),
              CartTotal(),
              ElevatedButton(
                  onPressed: () {
                    print('Bought');
                  },
                  child: Text(
                    'BUY',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}

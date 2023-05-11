import 'package:flutter/material.dart';
import 'package:mercad0_capstone/Controller/cart_controller.dart';
import 'package:get/get.dart';

class CartTotal extends StatelessWidget {
  final CartController controller = Get.find();
  static const TextStyle _totalTextStyle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

 CartTotal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total',
              style: _totalTextStyle,
            ),
            Spacer(),
            Text(
              '₱${controller.total}',
              style: _totalTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mercad0_capstone/Auth/ProfilePage.dart';

class Organization extends StatelessWidget {
  const Organization({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(child: Text('organization')),
        ElevatedButton(
            onPressed: () => {Get.to(() => ProfilePage())},
            child: Text('GO to Login'))
      ],
    );
  }
}

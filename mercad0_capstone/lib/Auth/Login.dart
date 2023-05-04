import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mercad0_capstone/Auth/SignUp.dart';
import 'package:mercad0_capstone/main.dart';

import '../Farmer Screens/farmer_screen.dart';
import '../Organization Screens/organization_screen.dart';
import '../Screens/home_screen.dart';
import 'ProfilePage.dart';

class Login extends StatefulWidget {
  final VoidCallback onClickedSignUp;

  const Login({Key? key, required this.onClickedSignUp}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListView(children: <Widget>[
        Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Log in',
              style: TextStyle(fontSize: 20),
            )),
        Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Sign In to your account',
              style: TextStyle(fontSize: 15),
            )),
        Container(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
              labelText: 'User Name',
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: TextField(
            obscureText: true,
            controller: passwordController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
              labelText: 'Password',
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            print("forgot Clicked");
          },
          child: const Text(
            'Forgot Password',
          ),
        ),
        Container(
            height: 50,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: ElevatedButton(
              child: const Text('Login'),
              onPressed: signIn,
            )),
        SizedBox(
          height: 50,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUp()),
                );
              },
              child: Text('Sign Up'),
            ),
          ],
        )
      ]),
    );
  }

  Future signIn() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text('Please wait... '),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'))
        ],
      ),
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: nameController.text.trim(),
        password: passwordController.text.trim(),
      );
      // navigate to the appropriate screen based on user role
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
      final userSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      final userData = userSnapshot.data() as Map<String, dynamic>;
      if (userData["role"] == 'customer') {
        Get.offAll(() => HomeScreen());
      } else if (userData['role'] == 'farmer') {
        Get.offAll(() => Farmers());
      } else if (userData['role'] == 'organization') {
        Get.offAll(() => Organization());
      } else {
        Get.offAll(() => ProfilePage());
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        navigatorKey.currentState!.pop();
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Incorrect email or password'),
            content: Text('Please enter valid email and password'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'))
            ],
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }
}

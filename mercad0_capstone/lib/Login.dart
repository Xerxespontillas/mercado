import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
 TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
   @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
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
                  'Sign to your account',
                  style: TextStyle(fontSize: 15),
                )),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
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
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            TextButton(
              onPressed: () {
               print("forgot Clicked");
              },
              child: const Text('Forgot Password',),
            ),
            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  child: const Text('Login'),
                  onPressed: signIn,
                )
            ),
            Row(
              children: <Widget>[
                const Text('Does not have account?'),
                TextButton(
                  child: const Text(
                    'Sign in',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                     print("Sign up Clicked");
                  },
                )
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ],
        ));
  }

Future signIn() async{
await FirebaseAuth.instance.signInWithEmailAndPassword(
  email:nameController.text.trim(),
  password: passwordController.text.trim(), 
);
}
  }
import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mercad0_capstone/main.dart';
//import 'package:mercad0_capstone/Utilities/Utils.dart';
class SignUp extends StatefulWidget {
  final VoidCallback onClickedSignIn;

  const SignUp({Key? key,required this.onClickedSignIn}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();
 TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
   @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: formKey,
          child: ListView(
          children: <Widget>[
            Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 20),
                )),
                Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Register Account',
                  style: TextStyle(fontSize: 15),
                )),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'User Name',
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (email)=>
                   email != null && ! EmailValidator.validate(email)
                    ? 'Enter a valid email'
                    : null,
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextFormField(
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value)=>
                   value != null && value.length < 6
                    ? 'Password must be minimum of 6 characters'
                    : null,
              ),
            ),
            SizedBox(height: 10,)
            ,
            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  child: const Text('Sign Up'),
                  onPressed: signUp,
                )
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.black,fontSize: 15),
                     text: ('Already have account?  '),
                     children: [
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                      ..onTap= widget.onClickedSignIn,
                      text: 
                        'Log In',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 20,
                        color: Colors.blue),
                    )
                  ],
                  ),
                 ),
              ],
            ),
          ],
        )));
  }

Future signUp() async{
  final isValid = formKey.currentState!.validate();
  if(!isValid) return;
  showDialog(context: context, 
  barrierDismissible: false,
  builder: (context)=> Center(child: CircularProgressIndicator()));
try {
  await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email:nameController.text.trim(),
    password: passwordController.text.trim(), 
  );
} on Exception catch (e) {
 print(e);

 //Utils.showSnackBar(e.message);
}
navigatorKey.currentState!.popUntil((route)=>route.isFirst);
}
  }
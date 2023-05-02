import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mercad0_capstone/main.dart';
import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:email_validator/email_validator.dart';

//import 'package:mercad0_capstone/Utilities/Utils.dart';
class SignUp extends StatefulWidget {
  final VoidCallback onClickedSignUp;

  const SignUp({Key? key, required this.onClickedSignUp}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();
  final UserNameController = TextEditingController();
  final passwordController = TextEditingController();
  final fullNameController = TextEditingController();
  final orgController = TextEditingController();
  var roleController;
  int _value = 0;
  bool _farmerOrgVisible = false;
  @override
  void dispose() {
    UserNameController.dispose();
    passwordController.dispose();
    fullNameController.dispose();
    orgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
            key: formKey,
            child: SingleChildScrollView(
                child: Column(
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
                    alignment: Alignment.centerLeft,
                     padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextFormField(
                    obscureText: false,
                    controller: fullNameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      labelText: 'Full Name',
                    ),
                  ),
                ),
              
               
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: UserNameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      labelText: 'User Name',
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (email) =>
                        email != null && !EmailValidator.validate(email)
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
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      labelText: 'Password',
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => value != null && value.length < 6
                        ? 'Password must be minimum of 6 characters'
                        : null,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(child: myRadioButton(roleController)),
                Container(
                  child: _farmerOrgVisible == true
                      ? Container(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: TextFormField(
                            obscureText: false,
                            controller: orgController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.0)),
                              ),
                              labelText: 'Organization',
                            ),
                          ),
                        )
                      : SizedBox(
                          height: 20,
                        ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                    height: 50,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton(
                      child: const Text('Sign Up'),
                      onPressed: signUp,
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: TextStyle(color: Colors.black, fontSize: 15),
                        text: ('Already have account?  '),
                        children: [
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = widget.onClickedSignUp,
                            text: 'Log In',
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
            ))));
  }

  Future signUp() async {
  final isValid = formKey.currentState!.validate();
  if (!isValid) return;
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          Center(child: CircularProgressIndicator()));
  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: UserNameController.text.trim(),
      password: passwordController.text.trim(),
    ).timeout(Duration(seconds: 10)); // set a timeout value of 10 seconds
    // set the value of roleController based on the selected radio button
    if (_value == 1) {
      roleController = 'customer';
    } else if (_value == 2) {
      roleController = 'farmer';
    }
    // add details
    adduserDetails(
      fullNameController.text.trim(),
      roleController,
      orgController.text.trim(),
    );
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  } catch (e) {
    // handle the error
    print('Error: $e');
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Error'),
              content: Text('The database took too long to respond.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ));
  }
}

Future<void> adduserDetails(String fullName, String role, String org) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    Map<String, dynamic> userData = {
      "fullName": fullName,
      "role": role,
      "organization": org,
      "email": FirebaseAuth.instance.currentUser!.email,
      "uid": uid
    };
    FirebaseFirestore.instance.collection('users').doc(uid).set(userData);
}

  Widget myRadioButton(TextEditingController roleController) {
    return Row(
      children: [
        Row(children: [
          Radio(
            value: 1,
            groupValue: _value,
            onChanged: (value) {
              setState(() {
                _value = value as int;
                _farmerOrgVisible = false;
              });
            },
          ),
          SizedBox(
            width: 10,
          ),
          Text('Customer'),
        ]),
        Row(children: [
          Radio(
            value: 2,
            groupValue: _value,
            onChanged: (value) {
              setState(() {
                _value = value as int;
                _farmerOrgVisible = true;
              });
            },
          ),
          SizedBox(
            width: 10,
          ),
          Text('Farmer')
        ]),
        Row(children: [
          Radio(
            value: 3,
            groupValue: _value,
            onChanged: (value) {
              setState(() {
                _value = value as int;
                _farmerOrgVisible = false;
              });
            },
          ),
          SizedBox(
            width: 10,
          ),
          Text('Organization')
        ]),
      ],
    );
  }
}

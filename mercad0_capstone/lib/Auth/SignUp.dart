import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mercad0_capstone/main.dart';
 import 'dart:convert';
//import 'package:mercad0_capstone/Utilities/Utils.dart';
class SignUp extends StatefulWidget {
  final VoidCallback onClickedSignUp;

  const SignUp({Key? key,required this.onClickedSignUp}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();
 final UserNameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final addressController = TextEditingController();
  final phoneNumberController = TextEditingController();
    final fullNameController = TextEditingController();
  var roleController;
  int _value=0;
  @override
  void dispose(){
UserNameController.dispose();
passwordController.dispose();
confirmPasswordController.dispose();
addressController.dispose();
phoneNumberController.dispose();
fullNameController.dispose();
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
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextFormField(
                obscureText: false,
                controller: fullNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(borderRadius:BorderRadius.all(Radius.circular(12.0)),),
                  labelText: 'Full Name',
                ),
              ),
            ),
             Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextFormField(
                obscureText: false,
                controller: addressController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(borderRadius:BorderRadius.all(Radius.circular(12.0)),),
                  labelText: 'Address',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextFormField(
                obscureText: false,
                controller: phoneNumberController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(borderRadius:BorderRadius.all(Radius.circular(12.0)),),
                  labelText: 'Phone Number',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: UserNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(borderRadius:BorderRadius.all(Radius.circular(12.0)),),
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
                  border: OutlineInputBorder(borderRadius:BorderRadius.all(Radius.circular(12.0)),),
                  labelText: 'Password',
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value)=>
                   value != null && value.length < 6
                    ? 'Password must be minimum of 6 characters'
                    : null,
              ),
            ),
            SizedBox(height: 10,),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextFormField(
                obscureText: true,
                controller: confirmPasswordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius:BorderRadius.all(Radius.circular(12.0)),
                  ),
                  labelText: 'Confirm Password',
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value)=>
                   value != null && value.length < 6
                    ? 'Password must be minimum of 6 characters'
                    : null,
              ),
            ),
            SizedBox(height: 20,),
         Container(
  child:myRadioButton (roleController) 
  ),

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
                      ..onTap= widget.onClickedSignUp,
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
        )
        )));
  }

Future signUp() async{
  final isValid = formKey.currentState!.validate();
  if(!isValid) return;
  showDialog(context: context, 
  barrierDismissible: false,
  builder: (context)=> Center(child: CircularProgressIndicator()));
if(passWordConfirmed()){
  try {
  await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email:UserNameController.text.trim(),
    password: passwordController.text.trim(), 
  );
} on Exception catch (e) {
 print(e);
 //Utils.showSnackBar(e.message);
}
// add details
adduserDetails(fullNameController.text.trim(), addressController.text.trim(),roleController,int.parse(phoneNumberController.text.trim()));
}
navigatorKey.currentState!.popUntil((route)=>route.isFirst);
}

Future adduserDetails(String fullName, String address,String role, int phoneNumber)async{
  String roleVal;
  if(_value==1){
    roleVal='customer';
    roleController=roleVal;
    role=roleController;
  }
  else if (_value==2){
    roleVal='farmer';
     roleController=roleVal; role=roleController;
  }
  else if(_value==3){
    roleVal='organization';
    roleController=roleVal; role=roleController;
  }
  await FirebaseFirestore.instance.collection('users').add({
    'full name': fullName,
    'address': address,
    'phone number': phoneNumber,
    'role': role,
  });
}

bool passWordConfirmed(){
  if(passwordController.text.trim()==confirmPasswordController.text.trim()){
    return true;
  }
  else {return false;}
}
Widget myRadioButton(TextEditingController roleController){
return Row(
children: [
   Row(
            children: [
             Radio(
          value: 1, 
          groupValue: _value, 
          onChanged: (value){
            setState(() {
               _value= value as int ;
               print(_value);
            });
          },
      ),SizedBox(width: 10,),
      Text ('Customer'),
      ]),
      Row(
            children: [
             Radio(
          value:2, 
          groupValue: _value, 
          onChanged: (value){
            setState(() {
               _value= value as int;
               print(_value);
            });
          },
      ),SizedBox(width: 10,),
      Text('Farmer')]
      ),
      Row(
            children: [
             Radio(
          value:3, 
          groupValue: _value, 
          onChanged: (value){
            setState(() {
               _value= value as int;
               print(_value);
            });
          },
      ),
      SizedBox(width: 10,),
      Text('Organization')
      ]),
],
);
                      
  }
}
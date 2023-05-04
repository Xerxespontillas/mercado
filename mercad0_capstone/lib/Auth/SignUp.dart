import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
<<<<<<< HEAD
import 'package:firebase_storage/firebase_storage.dart';
=======
>>>>>>> 97939cb5d9d661a2235fc986a58da5f2b77ad7b4
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mercad0_capstone/main.dart';
import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:email_validator/email_validator.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final fullNameController = TextEditingController();
  final orgController = TextEditingController();
  final roleController = TextEditingController();
  var _imageFile = File('Assets\Mercado_Icon.png');
  bool _farmerOrgVisible = false;
  var _value = 1;

  void _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null) {
      setState(() {
        _imageFile = File(result.files.single.path!);
      });
    } else {
      Navigator.pop(context); 
    }
  }

  @override
  void dispose() {
    userNameController.dispose();
    passwordController.dispose();
    fullNameController.dispose();
    orgController.dispose();
    roleController.dispose();
    super.dispose();
  }

  Widget myRadioButton(controller) {
    return Column(
      children: [
        RadioListTile(
          title: const Text('Customer'),
          value: 1,
          groupValue: _value,
          onChanged: (value) {
            setState(() {
              _value = value as int;
              _farmerOrgVisible = false;
              roleController.text = 'Customer';
            });
          },
        ),
        RadioListTile(
          title: const Text('Farmer'),
          value: 2,
          groupValue: _value,
          onChanged: (value) {
            setState(() {
              _value = value as int;
              _farmerOrgVisible = false;
              roleController.text = 'Farmer';
            });
          },
        ),
        RadioListTile(
          title: const Text('Organization'),
          value: 3,
          groupValue: _value,
          onChanged: (value) {
            setState(() {
              _value = value as int;
              _farmerOrgVisible = true;
              roleController.text = 'Organization';
            });
          },
        ),
      ],
    );
  }

  void signUp() async {
    final isValid = formKey.currentState!.validate();
    if (isValid) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: userNameController.text.trim(),
          password: passwordController.text.trim(),
        );
        if (userCredential != null) {
          final userId = userCredential.user!.uid;
          final storageRef = FirebaseStorage.instance
              .ref()
              .child('images/${_imageFile.path.split('/').last}');

        
            await storageRef.putFile(_imageFile);
            final url = await storageRef.getDownloadURL();
            // Save the download URL to Firestore or your database
      
          
          await FirebaseFirestore.instance.collection('users').doc(userId).set({
            'id': userId,
            'full_name': fullNameController.text,
            'username': userNameController.text.trim(),
            'role': roleController.text,
            'organization': orgController.text,
            'image_url': url,
          });
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const MyApp()),
              (Route<dynamic> route) => false);
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
                  'The password provided is too weak. Please choose a strong password.')));
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
                  'An account already exists with this email address. Please try a different email.')));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'An error occurred while signing up. Please try again later.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: formKey,
<<<<<<< HEAD
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: InkWell(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage: _imageFile != null
                          ? FileImage(_imageFile)
                          : const AssetImage('Assets\Mercado_Icon.png')
                              as ImageProvider,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Account Type'),
                myRadioButton(roleController),
                Visibility(
                  visible: _farmerOrgVisible,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      const Text('Organization Name'),
                      TextFormField(
                        controller: orgController,
                        validator: (value) {
                          if (_farmerOrgVisible && value!.isEmpty) {
                            return 'Please enter your organization name.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Text('Full Name'),
                TextFormField(
                  controller: fullNameController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your full name.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                const Text('Email'),
                TextFormField(
                  controller: userNameController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email address.';
                    }
                    if (!EmailValidator.validate(value)) {
                      return 'Please enter a valid email address.';
                    }
                    return null;
                  },
=======
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
>>>>>>> 97939cb5d9d661a2235fc986a58da5f2b77ad7b4
                ),
                const SizedBox(height: 10),
                const Text('Password'),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a password.';
                    }
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters long.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                SizedBox(
<<<<<<< HEAD
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: signUp,
                    child: const Text('Sign Up'),
                  ),
                ),
              ],
            ),
=======
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
>>>>>>> 97939cb5d9d661a2235fc986a58da5f2b77ad7b4
          ),
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mercad0_capstone/main.dart';
import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:email_validator/email_validator.dart';

import 'Login.dart';

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
  var _imageFile;
  bool _farmerOrgVisible = false;
  var _value = 1;

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (mounted) {
      if (result != null) {
        setState(() {
          _imageFile = File(result.files.single.path!);
        });
      } else {
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    userNameController.dispose();
    passwordController.dispose();
    fullNameController.dispose();
    orgController.dispose();
    //roleController.dispose();
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
              roleController.text = 'Customer';
              _value = value as int;
              _farmerOrgVisible = false;
            });
          },
        ),
        RadioListTile(
          title: const Text('Farmer'),
          value: 2,
          groupValue: _value,
          onChanged: (value) {
            setState(() {
              roleController.text = 'Farmer';
              _value = value as int;
              _farmerOrgVisible = false;
            });
          },
        ),
        RadioListTile(
          title: const Text('Organization'),
          value: 3,
          groupValue: _value,
          onChanged: (value) {
            setState(() {
              roleController.text = 'Organization';
              _value = value as int;
              _farmerOrgVisible = true;
            });
          },
        ),
      ],
    );
  }

  Future<Login> signUp() async {
    final isValid = formKey.currentState!.validate();
    if (isValid) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: userNameController.text.trim(),
          password: passwordController.text.trim(),
        );
        if (userCredential != null) {
          if (_imageFile != null) {
            final userId = userCredential.user!.uid;
            final storageRef = FirebaseStorage.instance
                .ref()
                .child('profile/${_imageFile.path.split('/').last}');
            await storageRef.putFile(_imageFile);
            final imageUrl = await storageRef.getDownloadURL();
            final userData = {
              'email': userNameController.text.trim(),
              'fullName': fullNameController.text.trim(),
              'role': roleController.text.trim(),
              'org': orgController.text.trim(),
              'imageUrl': imageUrl,
            };
            await FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .set(userData);
            // Return a new instance of the Login widget
            return Login(onClickedSignUp: () {});
          }
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
    // Return a new instance of the Login widget
    return Login(onClickedSignUp: () {});
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 70,
                        backgroundImage: _imageFile != null
                            ? FileImage(_imageFile)
                            : const AssetImage('lib/Assets/logo.png')
                                as ImageProvider,
                      ),
                      ElevatedButton(
                        onPressed:
                            _pickImage, // Call _pickImage() to select image file
                        child: const Text('Choose Image'),
                      ),
                    ],
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
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: signUp,
                    child: const Text('Sign Up'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

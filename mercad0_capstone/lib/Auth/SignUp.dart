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

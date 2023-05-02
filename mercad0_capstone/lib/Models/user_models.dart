import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Users {
  final fullName;
    final address;
 final phoneNumber;
  final role;
   final org;
  Users({
required this.fullName,
required this.role,
required this.address,
required this.org,
required this.phoneNumber,
  });

  Map<String, dynamic> toJson()=> {
      'fullName': fullName,
      'role': role,
      'address': address,
      'org': org,
      'phoneNumber': phoneNumber,
    };

     static Users fromJson(Map<String, dynamic> json) => Users(
    fullName: json['full name'],
       role: json['role'],
       address: json['address'],
      org: json['org'],
       phoneNumber: json['phone number'],
     );
       
    }
  

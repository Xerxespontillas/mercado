import 'package:flutter/material.dart';
import 'package:mercad0_capstone/main.dart';
class Utils{

  showSnackBar(String? text){
    if(text== null) return;
    final snackbar = SnackBar(content: Text(text),backgroundColor: Colors.red);
        
    messengerKey.currentState!
    ..removeCurrentSnackBar()
    ..showSnackBar(snackbar);
  }
}
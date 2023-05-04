  import 'package:flutter/material.dart';
  import 'Login.dart';
  import 'SignUp.dart';

  class AuthPage extends StatefulWidget {
    const AuthPage({Key? key}) : super(key: key);

    @override
    State<AuthPage> createState() => _AuthPageState();
  }

  class _AuthPageState extends State<AuthPage> {
    bool isLogin = true;
    @override
    Widget build(BuildContext context) => isLogin
        ? Login(onClickedSignUp: toggle)
        : SignUp();
    void toggle() => setState(() => isLogin = !isLogin);
  }

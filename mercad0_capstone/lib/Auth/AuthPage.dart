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
<<<<<<< HEAD
        : SignUp();
=======
        : SignUp(onClickedSignUp: toggle);
>>>>>>> 97939cb5d9d661a2235fc986a58da5f2b77ad7b4
    void toggle() => setState(() => isLogin = !isLogin);
  }

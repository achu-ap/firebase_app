import 'package:firebase_app/screens/authenticate/signin.dart';
import 'package:firebase_app/screens/authenticate/signup.dart';
import 'package:flutter/widgets.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool isSignup = false;

  void toggleView(){
    setState(() {
      isSignup = !isSignup;
    });
  }
  @override
  Widget build(BuildContext context) {
    return isSignup ? Signup(toggleView : toggleView) : Signin( toggleView : toggleView);
  }
}
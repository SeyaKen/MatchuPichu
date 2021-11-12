import 'package:flutter/material.dart';
import 'package:machupichu/mailSignin/TestMailLogIn.dart';
import 'package:machupichu/mailSignin/TestMailRegister.dart';

class TestAuthenticate extends StatefulWidget {
  @override
  _TestAuthenticateState createState() => _TestAuthenticateState();
}

class _TestAuthenticateState extends State<TestAuthenticate> {
  bool showSignIn = false;
  void toggleView() {
    //print(showSignIn.toString());
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return testRegister(toggleView);
    } else {
      return testLogIn(toggleView);
    }
  }
}

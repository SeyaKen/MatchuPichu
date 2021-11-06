import 'package:flutter/material.dart';
import 'package:machupichu/mailSignin/mailRegister.dart';
import 'package:machupichu/mailSignin/mailSignIn.dart';

class mailAuthenticate extends StatefulWidget {
  @override
  _mailAuthenticateState createState() => _mailAuthenticateState();
}

class _mailAuthenticateState extends State<mailAuthenticate> {
  bool showSignIn = false;
  void toggleView() {
    //print(showSignIn.toString());
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return mailRegister(toggleView);
    } else {
      return mailSignIn(toggleView);
    }
  }
}

import 'package:flutter/material.dart';
import 'package:machupichu/services/auth.dart';

class SignOut extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () async {
              await AuthMethods().signOut(context);
            },
            child: Text('ログアウト'),
          ),
        ],
      ),
    ));
  }
}

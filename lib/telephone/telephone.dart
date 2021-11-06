import 'package:flutter/material.dart';

class Telephone extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('※このページはただいま作成中です。',
              style: TextStyle(color: Colors.red, fontSize: 20)),
          SizedBox(
            height: 100,
          ),
          SizedBox(
            height: 200,
            width: 200,
            child: Image.asset('images/ojigi_animal_usagi.png'),
          ),
        ],
      ),
    ));
  }
}

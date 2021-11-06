import 'package:flutter/material.dart';

class GoriyouShousai extends StatelessWidget {
  String goiken;
  GoriyouShousai(this.goiken);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Text(goiken),
          ),
        ),
      ),
    );
  }
}

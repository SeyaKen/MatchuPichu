import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:machupichu/services/database.dart';
import 'package:machupichu/services/editDatabase.dart';

class GoikenScreen extends StatefulWidget {
  @override
  _GoikenScreenState createState() => _GoikenScreenState();
}

class _GoikenScreenState extends State<GoikenScreen> {
  final _formKey = GlobalKey<FormState>();
  String uid = FirebaseAuth.instance.currentUser!.uid;
  String goiken = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3333333333,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3333333333,
                child: Text(
                  'ご意見箱',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              Flexible(
                child: InkWell(
                  onTap: () async {
                    await DatabaseService(uid).addGoiken(goiken.trim());
                    Navigator.pop(context);
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3333333333,
                    child: Center(
                      child: Text(
                        '送信する',
                        style: TextStyle(
                          color: Color(0xFFed1b24).withOpacity(0.77),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          )),
      body: SingleChildScrollView(
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                  '※ご意見、クレーム、ご要望、作って欲しいアプリ、直して欲しい機能、追加したい機能、などなんでも構いませんので、何かありましたら、ぜひ下の記入欄からご意見をお聞かせください。'),
              Form(
                key: _formKey,
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'ご意見、クレーム、ご要望を入力',
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  onChanged: (val) {
                    setState(() => goiken = val);
                    print(goiken);
                  },
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}

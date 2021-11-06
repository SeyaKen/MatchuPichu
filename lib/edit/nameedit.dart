import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:machupichu/services/editDatabase.dart';

class NameEdit extends StatefulWidget {
  String name;
  NameEdit(this.name);
  @override
  _NameEditState createState() => _NameEditState(name);
}

class _NameEditState extends State<NameEdit> {
  String name;
  _NameEditState(this.name);
  final _formKey = GlobalKey<FormState>();
  String uid = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              Text(
                'ニックネーム',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
              ),
            ],
          )),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Form(
              key: _formKey,
              child: TextFormField(
                initialValue: name,
                onChanged: (val) {
                  setState(() => name = val);
                },
              ),
            ),
            SizedBox(
              height: 30,
            ),
            SizedBox(
              width: 100,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  await editService(uid).updateUserName(name);
                  Navigator.pop(context);
                },
                child: Text('変更する'),
                style: ElevatedButton.styleFrom(
                    primary: Color(0xFFed1b24).withOpacity(0.8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10000.0),
                    )),
              ),
            )
          ],
        ),
      )),
    );
  }
}

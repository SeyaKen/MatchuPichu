import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:machupichu/services/editDatabase.dart';

class ExEdit extends StatefulWidget {
  String ex;
  ExEdit(this.ex);
  @override
  _ExEditState createState() => _ExEditState(ex);
}

class _ExEditState extends State<ExEdit> {
  String ex;
  _ExEditState(this.ex);
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
                  '自己紹介',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              Flexible(
                child: InkWell(
                  onTap: () async {
                    await editService(uid).updateUserEx(ex);
                    Navigator.pop(context);
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3333333333,
                    child: Center(
                      child: Text(
                        '変更する',
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
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Form(
              key: _formKey,
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: '自己紹介文を入力',
                  border: InputBorder.none,
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                initialValue: ex,
                onChanged: (val) {
                  setState(() => ex = val);
                },
              ),
            ),
          ],
        ),
      )),
    );
  }
}

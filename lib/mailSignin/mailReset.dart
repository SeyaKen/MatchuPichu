import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MailResetScreen extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<MailResetScreen> {
  // ここでauth.dartで作ったクラスを_authに代入
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  String email = '';
  dynamic error;
  bool eye = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            elevation: 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 30,
                  color: Colors.black,
                ),
                SizedBox(
                  width: 10,
                ),
                Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 30,
                  color: Colors.white,
                ),
              ],
            )),
        body: GestureDetector(
          onTap: () {
            final FocusScopeNode currentScope = FocusScope.of(context);
            if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
              FocusManager.instance.primaryFocus!.unfocus();
            }
          },
          child: Form(
            key: _formKey,
            child: Center(
              child: Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height * 0.85,
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: TextFormField(
                            onChanged: (val) {
                              setState(() => email = val);
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)),
                              hintText: 'メールアドレス',
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 17),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                  width: 1.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFed1b24),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 58,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  if (_formKey.currentState!.validate() &&
                                      email.length > 15 &&
                                      email
                                          .substring(email.length - 15)
                                          .contains('@g.chuo-u.ac.jp')) {
                                    _auth.sendPasswordResetEmail(email: email);
                                    Navigator.pop(context);
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return CupertinoAlertDialog(actions: [
                                            CupertinoDialogAction(
                                              isDefaultAction: true,
                                              child: const Text("閉じる"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ], title: Text('正しいメールアドレスを入力してください'));
                                        });
                                  }
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: Center(
                                    child: Text(
                                      'ログインリンクを送信',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

import 'package:email_auth/email_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:machupichu/mailSignin/mailAuth.dart';

class testRegister extends StatefulWidget {
  final Function toggleView;
  testRegister(this.toggleView);

  @override
  _testRegisterState createState() => _testRegisterState();
}

class _testRegisterState extends State<testRegister> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  var _usernameController = TextEditingController();

  String email = '';
  String password = '';
  dynamic error;
  bool eye = true;

  bool validateStructure(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  void sendOTP() async {
    EmailAuth.sessionName = "MachuPichuの認証コードです。";
    var res = await EmailAuth.sendOtp(receiverMail: email);
    if (res) {
      print('送信しました');
    } else {
      CupertinoAlertDialog(
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text("閉じる"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
        title: Text('認証コードを送信できませんでした。メールアドレスをもう一度ご確認ください。'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('TEST',
                  style: TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold)),
              TextButton.icon(
                icon: Icon(Icons.person),
                label: Text('TESTログイン画面へ'),
                onPressed: () async {
                  widget.toggleView();
                },
              )
            ],
          ),
        ),
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
                    Row(
                      children: [
                        Text(
                          '新規登録',
                          style: TextStyle(color: Colors.black, fontSize: 30),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                          '※大学メールアドレスでないと登録できません。',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextFormField(
                        validator: (val) =>
                            val!.isEmpty
                                ? '正しいメールアドレスを入力してください'
                                : null,
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
                    Stack(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: TextFormField(
                            controller: _usernameController,
                            validator: (val) =>
                                validateStructure(_usernameController.text)
                                    ? null
                                    : '8文字以上で、大文字、小文字、記号を含むパスワードを入力してください',
                            obscureText: eye,
                            onChanged: (val) {
                              setState(() => password = val);
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)),
                              hintText: 'パスワード',
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
                        Positioned(
                          top: 16,
                          right: 15,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                eye = !eye;
                              });
                            },
                            child: Icon(
                              eye
                                  ? FontAwesomeIcons.eyeSlash
                                  : FontAwesomeIcons.eye,
                              size: 23,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
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
                            onTap: () async {
                              if (_formKey.currentState!.validate() && validateStructure(_usernameController.text)) {
                                await _auth.registerWithEmailAndPassword(
                                    context,
                                    email.toString().trim(),
                                    password.toString().trim());
                              }
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Center(
                                child: Text(
                                  '新規登録する',
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
              ),
            ),
          ),
        ));
  }
}

import 'package:email_auth/email_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:machupichu/mailSignin/mailAuth.dart';

class NinShow1 extends StatefulWidget {
  String email, password;
  NinShow1(this.email, this.password);
  @override
  _NinShow1State createState() => _NinShow1State(email, password);
}

class _NinShow1State extends State<NinShow1> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email;
  String password;
  _NinShow1State(this.email, this.password);
  String ninshow = '';
  dynamic error;
  bool eye = true;

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

  void verifyOTP() async {
    var res = EmailAuth.validate(receiverMail: email, userOTP: ninshow);
    print(res);
    if (res) {
      try {
        print('成功');
        await _auth.signInWithEmailAndPassword(
            context, email.toString().trim(), password.toString().trim());
      } catch (e) {
        print(e.toString());
      }
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
            ], title: Text('正しい認証コードを入力してください'));
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            elevation: 0,
            title: Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 30,
                    color: Colors.black,
                  ),
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
                    Flexible(
                      child: Text(
                        'コードを入力してください',
                        style: TextStyle(color: Colors.black, fontSize: 25),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                          '届いたメールアドレスに記載されているコードを入力してください。',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextFormField(
                        onChanged: (val) {
                          setState(() => ninshow = val);
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          hintText: '認証コード（6桁）',
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
                        color: ninshow.length == 6
                            ? Color(0xFFed1b24)
                            : Color(0xFFed1b24).withOpacity(0.5),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 58,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () async {
                              if (email.length > 15 &&
                                  email
                                      .substring(email.length - 15)
                                      .contains('@g.chuo-u.ac.jp')) {
                                verifyOTP();
                              }
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Center(
                                child: Text(
                                  '新規登録',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () async {
                        if (_formKey.currentState!.validate() &&
                            email.length > 15 &&
                            email
                                .substring(email.length - 15)
                                .contains('@g.chuo-u.ac.jp')) {
                          sendOTP();
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Center(
                          child: Text(
                            '認証コードを再送信する',
                            style: TextStyle(
                                color: Color(0xFFed1b24), fontSize: 15),
                          ),
                        ),
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

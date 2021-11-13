import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:machupichu/mailSignin/mailAuth.dart';
import 'package:machupichu/mailSignin/reset.dart';

class testLogIn extends StatefulWidget {
  final Function toggleView;
  testLogIn(this.toggleView);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<testLogIn> {
  // ここでauth.dartで作ったクラスを_authに代入
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
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
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('TEST',
                  style: TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold)),
              TextButton.icon(
                icon: Icon(Icons.person),
                label: Text('TEST新規登録画面へ'),
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
                    Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'ログイン',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 30),
                            ),
                          ],
                        ),
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
                        Stack(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: TextFormField(
                                obscureText: eye,
                                onChanged: (val) {
                                  setState(() => password = val);
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey)),
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
                                  if (_formKey.currentState!.validate()) {
                                    await _auth.signInWithEmailAndPassword(
                                        context,
                                        email.toString().trim(),
                                        password.toString().trim());
                                  }
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: Center(
                                    child: Text(
                                      'ログイン',
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          child: Text('パスワードを忘れた場合'),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ResetScreen()));
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

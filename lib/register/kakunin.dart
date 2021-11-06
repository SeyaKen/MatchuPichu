import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:machupichu/register/zero_profile.dart';
import 'package:machupichu/settings/privacy.dart';
import 'package:machupichu/settings/riyoukiyaku.dart';

class Kakunin extends StatefulWidget {
  const Kakunin({Key? key}) : super(key: key);

  @override
  State<Kakunin> createState() => _KakuninState();
}

class _KakuninState extends State<Kakunin> {
  int index = 0;
  bool check = false;
  bool check0 = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.70,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: 100,
                            width: 100,
                            child: Image.asset('images/icon.png'),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text('MachuPichu',
                              style: TextStyle(
                                  color: Color(0xFFed1b24).withOpacity(0.77))),
                        ],
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(bottom: 25.0, left: 10.0),
                        child: Text('へようこそ！',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            )),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    Text('MachuPichuへの登録本当にありがとうございます。',
                        style: TextStyle(
                          fontSize: 20,
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Text('MachuPichuを使うにあたって必要な情報を得るためにいくつか質問をします。',
                        style: TextStyle(
                          fontSize: 20,
                        )),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        this.check = !check;
                      });
                    },
                    child: ListTile(
                        leading: check
                            ? Icon(
                                Icons.check_box,
                                color: Color(0xFFed1b24).withOpacity(0.77),
                              )
                            : Icon(Icons.check_box_outline_blank),
                        title: Text('18歳以上で大学生です。')),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        this.check0 = !check0;
                      });
                    },
                    child: ListTile(
                        leading: check0
                            ? Icon(
                                Icons.check_box,
                                color: Color(0xFFed1b24).withOpacity(0.77),
                              )
                            : Icon(Icons.check_box_outline_blank),
                        title: RichText(
                            text: TextSpan(
                                style: TextStyle(color: Colors.black),
                                children: [
                              TextSpan(text: 'MachuPichuの'),
                              TextSpan(
                                style: TextStyle(
                                    color: Color(0xFFed1b24).withOpacity(0.77)),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Riyoukiyaku(),
                                        ));
                                  },
                                text: '利用規約',
                              ),
                              TextSpan(text: '・'),
                              TextSpan(
                                style: TextStyle(
                                    color: Color(0xFFed1b24).withOpacity(0.77)),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Privacy(),
                                        ));
                                  },
                                text: 'プライバシーポリシー',
                              ),
                              TextSpan(text: 'の内容を確認の上、同意します。'),
                            ]))),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: InkWell(
        onTap: () {
          check == true && check0 == true
              ? Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => ZeroProfile(),
                    transitionDuration: Duration(seconds: 0),
                  ))
              : null;
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '次のページへ行く',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: check == true && check0 == true
                        ? Color(0xFFed1b24).withOpacity(0.77)
                        : Colors.grey),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 30,
                color: check == true && check0 == true
                    ? Color(0xFFed1b24).withOpacity(0.77)
                    : Colors.grey,
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

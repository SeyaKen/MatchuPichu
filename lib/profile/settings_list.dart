import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:machupichu/kanri/goiken_lists_screen.dart';
import 'package:machupichu/kanri/kanri.dart';
import 'package:machupichu/mailSignin/mailReset.dart';
import 'package:machupichu/profile/goiken_screen.dart';
import 'package:machupichu/profile/mibunnshoumei.dart';
import 'package:machupichu/services/auth.dart';
import 'package:machupichu/settings/privacy.dart';
import 'package:machupichu/settings/riyoukiyaku.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingList extends StatefulWidget {
  @override
  State<SettingList> createState() => _SettingListState();
}

class _SettingListState extends State<SettingList> {
  var listItem = ['利用規約', 'プライバシーポリシー', 'ログアウト', 'ご意見箱', 'お問い合わせ', '本人・年齢確認', 'パスワード変更'];
  late final a;
  late String m = '0';

  onScreenLoaded() async {
    this.a = FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.uid);
    try {
      a.get().then((docSnapshot) => {
            this.m = docSnapshot.get('kakunin'),
            setState(() {}),
          });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    onScreenLoaded();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Color(0xFFed1b24).withOpacity(0.77),
            elevation: 0,
            toolbarHeight: 60,
            automaticallyImplyLeading: false,
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
                InkWell(
                  onTap: () {
                    FirebaseAuth.instance.currentUser!.email ==
                            'a20.mpaf@g.chuo-u.ac.jp'
                        ? Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (_, __, ___) => KanriScreen(),
                              transitionDuration: Duration(seconds: 0),
                            ))
                        : null;
                  },
                  child: Text(
                    '設定',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Colors.white,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    FirebaseAuth.instance.currentUser!.email ==
                            'a20.mpaf@g.chuo-u.ac.jp'
                        ? Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (_, __, ___) => GoikenListsScreen(),
                              transitionDuration: Duration(seconds: 0),
                            ))
                        : null;
                  },
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 30,
                    color: Colors.transparent,
                  ),
                ),
              ],
            )),
        resizeToAvoidBottomInset: false,
        body: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.black38),
                  ),
                ),
                child: ListTile(
                  title: 
                  listItem[index] == 'パスワード変更'
                  ? Text(listItem[index])
                  : listItem[index] == 'ご意見箱'
                      ? Text(listItem[index])
                      : listItem[index] != '本人・年齢確認'
                          ? Text(listItem[index])
                          : listItem[index] == '本人・年齢確認' && this.m == '0'
                              ? Text(listItem[index])
                              : this.m == '1'
                                  ? Row(
                                      children: [
                                        Icon(
                                          Icons.change_circle,
                                          color: Color(0xFF9ece07),
                                          size: 30,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          '審査中',
                                          style: TextStyle(
                                            color: Color(0xFF9ece07),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    )
                                  : this.m == '2'
                                      ? Row(
                                          children: [
                                            Icon(
                                              Icons.check,
                                              color: Colors.blue,
                                              size: 30,
                                            ),
                                            SizedBox(width: 10),
                                            Text('審査完了',
                                                style: TextStyle(
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.bold,
                                                )),
                                          ],
                                        )
                                      : Row(
                                          children: [
                                            Icon(
                                              Icons.block_outlined,
                                              color: Colors.red,
                                              size: 30,
                                            ),
                                            SizedBox(width: 10),
                                            Flexible(
                                              child: Text('ここからもう一度提出し直してください',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                            ),
                                          ],
                                        ),
                  onTap: () async {
                    listItem[index] == 'パスワード変更'
                    ? Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (_, __, ___) => MailResetScreen(),
                                  transitionDuration: Duration(seconds: 0),
                                ))
                    : listItem[index] == '本人・年齢確認'
                        ? this.m == '0' || this.m == '3'
                            ? Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (_, __, ___) => Mibunnshoumei(),
                                  transitionDuration: Duration(seconds: 0),
                                ))
                            : null
                        : listItem[index] == 'お問い合わせ'
                            ? await launch(
                                "https://forms.gle/gZuXZbdcypLrY6GLA")
                            : listItem[index] == 'ご意見箱'
                                ? Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (_, __, ___) =>
                                          GoikenScreen(),
                                      transitionDuration: Duration(seconds: 0),
                                    ))
                                : listItem[index] != 'ログアウト'
                                    ? Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (_, __, ___) =>
                                              listItem[index] == '利用規約'
                                                  ? Riyoukiyaku()
                                                  : Privacy(),
                                          transitionDuration:
                                              Duration(seconds: 0),
                                        ))
                                    : showDialog(
                                        context: context,
                                        builder: (context) {
                                          return CupertinoAlertDialog(
                                              actions: [
                                                CupertinoDialogAction(
                                                  isDefaultAction: true,
                                                  child: const Text("いいえ"),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                CupertinoDialogAction(
                                                  textStyle: TextStyle(
                                                      color: Colors.red),
                                                  isDefaultAction: true,
                                                  child: const Text("はい"),
                                                  onPressed: () async {
                                                    await AuthMethods()
                                                        .signOut(context);
                                                  },
                                                ),
                                              ],
                                              title: Text(
                                                  'MachuPichuからログアウトしますか？'));
                                        });
                  },
                ));
          },
          itemCount: listItem.length,
        ),
      ),
    );
  }
}

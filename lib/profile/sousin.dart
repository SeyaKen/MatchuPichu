import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:machupichu/main_page.dart';
import 'package:machupichu/profile/profile_page.dart';
import 'package:machupichu/services/database.dart';
import 'package:provider/provider.dart';

class Sousin extends StatefulWidget {
  String uid;
  File imageFile;
  Sousin(this.uid, this.imageFile);

  @override
  _SousinState createState() => _SousinState();
}

class _SousinState extends State<Sousin> {
  DateTime? date;

  String getText() {
    if (date == null) {
      return '誕生日を選択してください';
    } else {
      return '生年月日  ${date!.year}/${date!.month}/${date!.day}';
    }
  }

  Future pickDate(BuildContext context) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: DateTime(DateTime.now().year - 20),
      firstDate: DateTime(DateTime.now().year - 25),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (newDate == null) return;

    setState(() {
      date = newDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DatabaseService>(
      create: (_) => DatabaseService(widget.uid),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            elevation: 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                Text(
                  '本人・年齢確認',
                  style: TextStyle(color: Colors.black),
                ),
                Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 30,
                  color: Colors.transparent,
                ),
              ],
            )),
        body: SingleChildScrollView(
          child: Center(
            child: SafeArea(
              child:
                  Consumer<DatabaseService>(builder: (context, model, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 30),
                    Container(
                        height: MediaQuery.of(context).size.width * 0.85,
                        width: MediaQuery.of(context).size.width * 0.85,
                        child: Image.file(
                          widget.imageFile,
                          fit: BoxFit.cover,
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: 45,
                      child: ElevatedButton(
                          onPressed: () {
                            pickDate(context);
                          },
                          child: Text(getText()),
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFFed1b24).withOpacity(0.77),
                          )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: 45,
                      child: ElevatedButton(
                          onPressed: () {
                            var sousintime = DateTime.now();
                            if (getText() != '誕生日を選択してください') {
                              DatabaseService(widget.uid).addMibunshou(
                                  widget.imageFile, getText(), sousintime);
                              FirebaseFirestore.instance
                                  .collection("user")
                                  .doc(widget.uid)
                                  .update({'kakunin': '1'});
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return CupertinoAlertDialog(
                                        actions: [
                                          CupertinoDialogAction(
                                            isDefaultAction: true,
                                            child: Text("ホーム画面に戻る"),
                                            onPressed: () async {
                                              Navigator.push(
                                                  context,
                                                  PageRouteBuilder(
                                                    pageBuilder: (_, __, ___) =>
                                                        MainPage(0, 'a', 'a',
                                                            'a', 0, 0),
                                                    transitionDuration:
                                                        Duration(seconds: 0),
                                                  ));
                                            },
                                          )
                                        ],
                                        title: Text(
                                            '本人・年齢確認のための画像を送信しました。承認確認作業が終わるまでお待ちください。※通常24時間以内に終わり次第、通知でお知らせします。'));
                                  });
                            }
                          },
                          child: Text('送信する'),
                          style: ElevatedButton.styleFrom(
                            primary: getText() == '誕生日を選択してください'
                                ? Colors.grey
                                : Color(0xFFed1b24).withOpacity(0.77),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10000.0),
                            ),
                          )),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

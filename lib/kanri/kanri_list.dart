import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:machupichu/kanri/goiken_lists_screen.dart';
import 'package:machupichu/kanri/kanri.dart';
import 'package:machupichu/services/database.dart';
import 'package:machupichu/tuuhou/tuuhou.dart';

class kanriListScreen extends StatefulWidget {

  @override
  State<kanriListScreen> createState() => _kanriListScreenState();
}

class _kanriListScreenState extends State<kanriListScreen> {

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          '管理画面',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                SizedBox(
                  height: 20,
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
                    Icons.check_box_outline_blank,
                    size: 80,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'ご意見箱',
                  style: TextStyle(),
                ),
              ],
            ),
            Column(
              children: [
                SizedBox(
                  height: 20,
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
                  child: Icon(
                    Icons.credit_card,
                    size: 80,
                    color: Colors.black,
                  ),
                ),
                Text(
                  '身分証明',
                ),
              ],
            ),
            Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                  },
                  child: Icon(
                    Icons.warning_rounded,
                    size: 80,
                    color: Colors.black,
                  ),
                ),
                Text(
                  '通報リスト',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

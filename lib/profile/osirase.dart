import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:machupichu/profile/osiraseDetail.dart';
import 'package:machupichu/services/database.dart';

class OsiraseList extends StatefulWidget {
  @override
  State<OsiraseList> createState() => _OsiraseListState();
}

class _OsiraseListState extends State<OsiraseList> {
  String? uid;
  Stream<QuerySnapshot<Object?>>? osiraseListsStream;
  int inde = 0;

  getMyUserUid() async {
    this.uid = await FirebaseAuth.instance.currentUser!.uid;
    setState(() {});
  }

  getOsirase() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    osiraseListsStream = await DatabaseService(uid).getOsirase();
    setState(() {});
    // setStateがよばれるたびにrebuildされる
  }

  onScreenLoaded() async {
    await getMyUserUid();
    getOsirase();
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
            automaticallyImplyLeading: false,
            backgroundColor: Color(0xFFed1b24).withOpacity(0.77),
            elevation: 0,
            toolbarHeight: 60,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () async {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 30,
                  ),
                ),
                Text('お知らせ'),
                Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 30,
                  color: Colors.transparent,
                ),
              ],
            )),
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: StreamBuilder<QuerySnapshot>(
              stream: osiraseListsStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  print(snapshot.error.toString());
                }
                return snapshot.hasData
                    ? ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          DocumentSnapshot ds = snapshot.data!.docs[index];
                          return OsiraseListTile(
                            ds['title'],
                            ds['naiyou'],
                            ds['ts'],
                          );
                        },
                      )
                    : Center(child: CircularProgressIndicator());
              }),
        ),
      ),
    );
  }
}

class OsiraseListTile extends StatefulWidget {
  final String title, naiyou;
  Timestamp ts;
  OsiraseListTile(this.title, this.naiyou, this.ts);

  @override
  _OsiraseListTile createState() => _OsiraseListTile();
}

class _OsiraseListTile extends State<OsiraseListTile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => OsiraseDetail(widget.title, widget.naiyou),
              transitionDuration: Duration(seconds: 0),
            ));
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(widget.title,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                Flexible(
                  child: Text(
                      widget.ts
                          .toDate()
                          .toString()
                          .substring(0, 16)
                          .replaceAll('-', '/'),
                      style: TextStyle(color: Colors.grey)),
                )
              ],
            ),
            SizedBox(height: 5),
            Text(widget.naiyou.length > 25
                ? widget.naiyou.substring(0, 25) + '...'
                : widget.naiyou),
          ],
        ),
      ),
    );
  }
}

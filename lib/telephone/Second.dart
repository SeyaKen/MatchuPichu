import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:machupichu/chat/chatScreen.dart';
import 'package:machupichu/chat/home_detailpage.dart';
import 'package:machupichu/settings/mibunnshoumei.dart';
import 'package:machupichu/services/database.dart';
import 'package:machupichu/tuuhou/tuuhou.dart';

int? notifications = 0;

class iineList extends StatefulWidget {
  @override
  _iineListState createState() => _iineListState();
}

class _iineListState extends State<iineList> {
  Stream<QuerySnapshot<Object?>>? iineStream;
  String? myUserUid;
  late final a;
  late String m = '0';

  getMyUserUid() async {
    this.myUserUid = await FirebaseAuth.instance.currentUser!.uid;
    setState(() {});
  }

  getChatRooms() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    iineStream = await DatabaseService(uid).getIineList();
    setState(() {});
    // setStateがよばれるたびにrebuildされる
  }

  onScreenLoaded() async {
    await getMyUserUid();
    getChatRooms();
  }

  @override
  void initState() {
    super.initState();
    onScreenLoaded();
  }

  Widget chatRoomsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: iineStream,
      builder: (context, snapshot1) {
        if (snapshot1.hasData) {
          print(snapshot1.error);
        }
        return snapshot1.hasData
            ? ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot1.data!.docs.length,
                itemBuilder: (context, index) {
                  if (0 == index) {
                    notifications = 0;
                  }
                  DocumentSnapshot ds = snapshot1.data!.docs[index];
                  String uid = FirebaseAuth.instance.currentUser!.uid;
                  // 相手の名前を代入
                  String username =
                      ds.id.replaceAll(uid, '').replaceAll('_', '');
                  return iineRoomListTile(
                    this.myUserUid!,
                    ds['$username'],
                    ds['${username}name'],
                    username,
                  );
                },
              )
            : Container(
                color: Colors.white,
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Color(0xFFed1b24).withOpacity(0.77),
            toolbarHeight: 88,
            elevation: 0,
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    Flexible(
                      child: Text(
                        'いいねをくれた人',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            )),
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 8,
              ),
              chatRoomsList(),
            ],
          ),
        ));
  }
}

class iineRoomListTile extends StatefulWidget {
  final String profilePicUrl, aitenoUid, aitenoName, jibunnnoUid;
  iineRoomListTile(
    this.aitenoUid,
    this.profilePicUrl,
    this.aitenoName,
    this.jibunnnoUid,
  );

  @override
  _iineRoomListTileState createState() => _iineRoomListTileState();
}

class _iineRoomListTileState extends State<iineRoomListTile> {
  String? profilePicUrl = '', name = '';
  late bool mute = false;
  late bool block = false;

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30000000),
                  child: widget.profilePicUrl.isNotEmpty
                      ? Image.network(
                          widget.profilePicUrl,
                          fit: BoxFit.cover,
                          height: MediaQuery.of(context).size.width * 0.15,
                          width: MediaQuery.of(context).size.width * 0.15,
                        )
                      : Container(height: 40, width: 40, color: Colors.grey),
                ),
                const SizedBox(width: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.aitenoName.length > 10
                                ? widget.aitenoName.substring(0, 10)
                                : widget.aitenoName,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ]),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) =>
                  HomeDetail(widget.jibunnnoUid, widget.aitenoUid),
              transitionDuration: Duration(seconds: 0),
            ));
      },
    );
  }
}

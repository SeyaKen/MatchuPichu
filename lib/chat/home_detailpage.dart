import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:machupichu/chat/chatScreen.dart';
import 'package:machupichu/settings/mibunnshoumei.dart';
import 'package:machupichu/services/database.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:machupichu/tuuhou/tuuhou.dart';

class HomeDetail extends StatefulWidget {
  final String uid, myUserUid;
  HomeDetail(this.uid, this.myUserUid);

  @override
  State<HomeDetail> createState() => _HomeDetailState();
}

class _HomeDetailState extends State<HomeDetail> {
  Stream<QuerySnapshot<Object?>>? homeDetailStream, iineStream;
  DocumentSnapshot? ds, dss;
  String youName = '';
  int? midokuuuu;
  String? chatRoomId;
  late final a;
  late String m;
  bool like = false;
  QuerySnapshot? I, You;

  getChatRoomIdByUsernames(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  onScreenLoaded() async {
    this.I = await DatabaseService(widget.myUserUid)
        .getUserInfo(widget.uid, widget.myUserUid);
    this.You = await DatabaseService(widget.myUserUid)
        .getUserInfo(widget.myUserUid, widget.uid);
    homeDetailStream = await DatabaseService(widget.uid).fetchImage();
    this.a =
        FirebaseFirestore.instance.collection("user").doc(widget.myUserUid);
    try {
      a.get().then((docSnapshot) => {
            this.m = docSnapshot.get('kakunin'),
            setState(() {}),
          });
    } catch (e) {}
    setState(() {});
  }

  getIine() async {
    this.iineStream =
        await DatabaseService(widget.uid).fetchIine(this.chatRoomId!);
  }

  createChatRoom() {
    Map<String, dynamic> chatRoomInfoMap = {
      'users': [widget.myUserUid, widget.uid],
      '${widget.myUserUid}midoku': 0,
      '${widget.uid}midoku': 0,
      '${widget.myUserUid}iine': 0,
      '${widget.uid}iine': 0,
      '${widget.myUserUid}nyuusitu': true,
      '${widget.uid}nyuusitu': false,
      '${widget.myUserUid}mute': false,
      '${widget.uid}mute': false,
      '${widget.myUserUid}block': false,
      '${widget.uid}block': false,
      'chatRoomId': chatRoomId,
      '${widget.uid}': this.You!.docs[0]["imageURL"],
      '${widget.myUserUid}': this.I!.docs[0]["imageURL"],
      "${widget.myUserUid}name": I!.docs[0]["name"],
      "${widget.uid}name": You!.docs[0]['name'],
    };
    DatabaseService(widget.myUserUid)
        .createChatRoom(chatRoomId!, chatRoomInfoMap);
  }

  @override
  void initState() {
    this.chatRoomId = getChatRoomIdByUsernames(widget.myUserUid, widget.uid);
    onScreenLoaded().then((value) => createChatRoom());
    getIine();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
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
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) =>
                            tuuhouScreen(widget.myUserUid, widget.uid),
                        transitionDuration: Duration(seconds: 0),
                      ));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.warning_rounded,
                        size: 30,
                        color: Colors.black,
                      ),
                      Text('通報',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          )),
                    ],
                  ),
                ),
              ),
            ],
          )),
      floatingActionButton: StreamBuilder<QuerySnapshot>(
          stream: iineStream,
          builder: (context, snapshot1) {
            if (snapshot1.data != null) {
              this.dss = snapshot1.data!.docs[0];
              print(snapshot1.error);
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(1000),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(3.0, 0), // changes position of shadow
                        ),
                      ],
                    ),
                    width: 60,
                    height: 60,
                    child: FloatingActionButton(
                      backgroundColor: Color(0xFFed1b24).withOpacity(0.77),
                      heroTag: 'like',
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        dss!['${widget.uid}iine'] == 0
                            ? setState(() {
                                like = true;
                                DatabaseService(widget.myUserUid)
                                    .updateIine(chatRoomId!, widget.uid);
                              })
                            : showDialog(
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
                                  ], title: Text('いいねは一人につき一回までしかできません。'));
                                });
                      },
                    )),
                SizedBox(height: 25),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1000),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(3.0, 0), // changes position of shadow
                      ),
                    ],
                  ),
                  width: 60,
                  height: 60,
                  child: FloatingActionButton(
                    heroTag: 'chat',
                    backgroundColor: Colors.grey[200],
                    onPressed: () async {
                      if (this.m == '2') {
                        String uid =
                            await FirebaseAuth.instance.currentUser!.uid;

                        final doc = await FirebaseFirestore.instance
                            .collection('user')
                            .doc(uid)
                            .get();

                        final doc1 = FirebaseFirestore.instance
                            .collection("chatrooms")
                            .doc(chatRoomId);

                        try {
                          doc1.get().then((docSnapshot) => {
                                this.midokuuuu =
                                    docSnapshot.get('${uid}midoku'),
                                FirebaseFirestore.instance
                                    .collection("chatrooms")
                                    .doc(chatRoomId)
                                    .update({'${uid}midoku': 0}),
                                FlutterAppBadger.updateBadgeCount(
                                    doc['notifications'] - this.midokuuuu),
                              });
                        } catch (e) {
                          print(e.toString());
                        }
                        Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (_, __, ___) => chatScreen(
                                widget.uid,
                                widget.myUserUid,
                                chatRoomId!,
                                this.youName,
                                ds!['imageURL'],
                              ),
                              transitionDuration: Duration(seconds: 0),
                            ));
                      } else if (this.m == '1') {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return CupertinoAlertDialog(
                                  actions: [
                                    CupertinoDialogAction(
                                      isDefaultAction: true,
                                      child: const Text("閉じる"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                  title: Text(
                                      'ただいま審査中です。審査が終わり次第開始できます。しばらくお待ちください。※審査終了の通知が来てからもこのポップアップが出る場合は一度アプリを完全に閉じてから、もう一度お試しください。'));
                            });
                      } else {
                        showDialog(
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
                                      textStyle: TextStyle(color: Colors.red),
                                      isDefaultAction: true,
                                      child: Text("はい"),
                                      onPressed: () async {
                                        Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (_, __, ___) =>
                                                  Mibunnshoumei(),
                                              transitionDuration:
                                                  Duration(seconds: 0),
                                            ));
                                      },
                                    )
                                  ],
                                  title: Text(
                                      '本人・年齢確認後でないとトークできません。本人・年齢確認画面に移動しますか？'));
                            });
                      }
                    },
                    child: Icon(
                      Icons.chat,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                ),
              ],
            );
          }),
      body: StreamBuilder<QuerySnapshot>(
          stream: homeDetailStream,
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              this.ds = snapshot.data!.docs[0];
              this.youName = ds!['name'];
            }
            return snapshot.hasData
                ? SingleChildScrollView(
                    child: SafeArea(
                      child: Column(
                        children: [
                          Container(
                            color: Colors.white,
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(1000),
                                      child: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        child: SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height:
                                              MediaQuery.of(context).size.width,
                                          child: Image.network(
                                            ds!['imageURL'],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      child: AnimatedOpacity(
                                        opacity: like ? 1.0 : 0.0,
                                        onEnd: () {
                                          if (like)
                                            setState(() {
                                              like = false;
                                            });
                                        },
                                        duration:
                                            const Duration(milliseconds: 400),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(1000),
                                          child: SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: AnimatedContainer(
                                                duration:
                                                    Duration(milliseconds: 400),
                                                color: Color(0xFFed1b24)
                                                    .withOpacity(0.77)
                                                    .withOpacity(0.7),
                                                child: Center(
                                                  child: Icon(
                                                    Icons.favorite,
                                                    color: Colors.white,
                                                    size: 150,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.035),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              ds!['name'],
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.01),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.85,
                                              child: Row(
                                                children: [
                                                  Text(
                                                    ds!['grade'],
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.01),
                                                  Text(
                                                    ds!['major'],
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.01),
                                            SizedBox(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Flexible(
                                                    child: Text(
                                                      ds!['hitokoto'],
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.black,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                'いいね!',
                                                style: TextStyle(fontSize: 12)
                                              ),
                                              Icon(
                                                Icons.favorite,
                                                size: 25,
                                                color: Color(0xFFed1b24).withOpacity(0.77),
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            ds!['iine'].toString(),
                                            style: TextStyle(
                                              fontWeight:
                                              FontWeight.bold,
                                              fontSize: 20,
                                            )
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.035),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.035),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                  child: Text(
                                    'プロフィール',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.01),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                  child: Row(
                                    children: [
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'ニックネーム',
                                              style: TextStyle(
                                                fontSize: 15,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              '学年',
                                              style: TextStyle(
                                                fontSize: 15,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              '学部',
                                              style: TextStyle(
                                                fontSize: 15,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              '身長',
                                              style: TextStyle(
                                                fontSize: 15,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              'ひとこと',
                                              style: TextStyle(
                                                fontSize: 15,
                                              ),
                                            ),
                                          ]),
                                      SizedBox(
                                        width: 100,
                                      ),
                                      Flexible(
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                ds!['name'],
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                ds!['grade'],
                                                style: TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                ds!['major'],
                                                style: TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                ds!['height'].toString() + 'cm',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                ds!['hitokoto'].length > 10
                                                    ? ds!['hitokoto']
                                                            .substring(0, 10) +
                                                        '...'
                                                    : ds!['hitokoto'],
                                                style: TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ]),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height *
                                        0.035),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height *
                                        0.035),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                  child: Text(
                                    '自己紹介',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.01),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                  child: Text(
                                    ds!['ex'],
                                  ),
                                ),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height *
                                        0.035),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Center(child: CircularProgressIndicator());
          }),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:machupichu/chat/chatScreen.dart';
import 'package:machupichu/settings/mibunnshoumei.dart';
import 'package:machupichu/services/database.dart';
import 'package:machupichu/tuuhou/tuuhou.dart';

int? notifications = 0;

class chatLists extends StatefulWidget {
  @override
  _chatListsState createState() => _chatListsState();
}

class _chatListsState extends State<chatLists> {
  Stream<QuerySnapshot<Object?>>? chatRoomsStream;
  String? myUserUid;
  late final a;
  late String m = '0';

  getMyUserUid() async {
    this.myUserUid = await FirebaseAuth.instance.currentUser!.uid;
    setState(() {});
  }

  getChatRooms() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    chatRoomsStream = await DatabaseService(uid).getChatRooms();
    setState(() {});
    // setStateがよばれるたびにrebuildされる
  }

  onScreenLoaded() async {
    await getMyUserUid();
    getChatRooms();
    this.a = FirebaseFirestore.instance.collection("user").doc(myUserUid);
    try {
      a.get().then((docSnapshot) => {
            this.m = docSnapshot.get('kakunin'),
            setState(() {}),
          });
    } catch (e) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    onScreenLoaded();
  }

  Widget chatRoomsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: chatRoomsStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print(snapshot.error);
        }
        return snapshot.hasData
            ? ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  if (0 == index) {
                    notifications = 0;
                  }
                  DocumentSnapshot ds = snapshot.data!.docs[index];
                  String uid = FirebaseAuth.instance.currentUser!.uid;
                  // 相手の名前を代入
                  String username =
                      ds.id.replaceAll(uid, '').replaceAll('_', '');
                  notifications =
                      (notifications! + ds['${this.myUserUid}midoku']) as int?;
                  if (index + 1 == snapshot.data!.docs.length) {
                    DatabaseService(uid).uploadNotification(notifications);
                    FlutterAppBadger.updateBadgeCount(notifications!);
                  }
                  return ChatRoomListTile(
                    ds['lastMessage'],
                    ds.id,
                    this.myUserUid!,
                    ds['$username'],
                    ds['sendBy'] == uid
                        ? ds['${username}You']
                        : ds['${username}I'],
                    ds['${this.myUserUid}midoku'],
                    ds['lastMessageSendTs'],
                    this.m,
                    ds.id.replaceAll(this.myUserUid!, '').replaceAll('_', ''),
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
                  Text(
                    'トーク',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.33,
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

class ChatRoomListTile extends StatefulWidget {
  final String lastMessage,
      chatRoomId,
      myUserUid,
      profilePicUrl,
      name,
      m,
      aitenoname;
  int mido;
  Timestamp ts;
  ChatRoomListTile(
      this.lastMessage,
      this.chatRoomId,
      this.myUserUid,
      this.profilePicUrl,
      this.name,
      this.mido,
      this.ts,
      this.m,
      this.aitenoname);

  @override
  _ChatRoomListTileState createState() => _ChatRoomListTileState();
}

class _ChatRoomListTileState extends State<ChatRoomListTile> {
  String? profilePicUrl = '', name = '';
  late bool mute = false;
  late bool block = false;

  doThisOnLaunch() async {
    final a = FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(widget.chatRoomId);
    try {
      a.get().then((docSnapshot) => {
            this.mute = docSnapshot.get('${widget.myUserUid}mute'),
            this.block = docSnapshot.get('${widget.myUserUid}block'),
            setState(() {}),
          });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    doThisOnLaunch();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: const ValueKey(0),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) async {
              await DatabaseService(widget.myUserUid)
                  .deleteChatRoom(widget.chatRoomId);
            },
            backgroundColor: Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: '削除',
          ),
          SlidableAction(
            onPressed: (context) {
              DatabaseService(widget.myUserUid)
                  .muteChatRoom(widget.chatRoomId, !mute);
              setState(() {
                this.mute = !mute;
              });
            },
            backgroundColor: Color(0xFF03c754),
            foregroundColor: Colors.white,
            icon: mute ? Icons.volume_off_sharp : Icons.volume_up_outlined,
            label: this.mute ? '通知オン' : '通知オフ',
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              !this.block
                  ? showDialog(
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
                                  DatabaseService(widget.myUserUid)
                                      .blockChatRoom(widget.chatRoomId);
                                  Navigator.of(context).pop();
                                  setState(() {
                                    this.block = !block;
                                  });
                                },
                              )
                            ],
                            title: Text(
                                'ブロックしている間はトーク履歴を見ることができません。また、もう一度追加したい場合は検索して追加し直す必要があります。それでもよろしいですか？'));
                      })
                  : setState(() {
                      DatabaseService(widget.myUserUid)
                          .kaijoChatRoom(widget.chatRoomId);
                      this.block = !block;
                    });
            },
            backgroundColor: Color(0xFFff334a),
            foregroundColor: Colors.white,
            icon: this.block ? Icons.do_not_disturb_on : Icons.block,
            label: this.block ? 'ブロック解除' : 'ブロック',
          ),
          SlidableAction(
            onPressed: (context) {
              Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => tuuhouScreen(),
                    transitionDuration: Duration(seconds: 0),
                  ));
            },
            backgroundColor: Colors.white,
            foregroundColor: Colors.red,
            icon: Icons.warning_rounded,
            label: '通報',
          ),
        ],
      ),
      child: InkWell(
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
                              widget.name.length > 10
                                  ? widget.name.substring(0, 10)
                                  : widget.name,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              widget.lastMessage.contains('firebasestorage')
                                  ? '画像を送信しました。'
                                  : widget.lastMessage.length > 15
                                      ? widget.lastMessage.substring(0, 15) +
                                          '...'
                                      : widget.lastMessage,
                            )
                          ]),
                    ],
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${widget.ts.toDate().toString().substring(10, 16)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30000000),
                    child: Container(
                      height: 25,
                      width: 25,
                      color: widget.mido == 0
                          ? Colors.white
                          : Color(0xFFed1b24).withOpacity(0.77),
                      child: Center(
                          child: Text(
                        widget.mido == 0 ? '' : widget.mido.toString(),
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        onTap: () {
          if (widget.m == '2') {
            FirebaseFirestore.instance
                .collection("chatrooms")
                .doc(widget.chatRoomId)
                .update({'${widget.myUserUid}midoku': 0});
            FlutterAppBadger.updateBadgeCount(notifications! - widget.mido);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => chatScreen(
                        widget.aitenoname,
                        widget.myUserUid,
                        widget.chatRoomId,
                        widget.name,
                        widget.profilePicUrl)));
          } else if (widget.m == '1') {
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
                  return CupertinoAlertDialog(actions: [
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
                              pageBuilder: (_, __, ___) => Mibunnshoumei(),
                              transitionDuration: Duration(seconds: 0),
                            ));
                      },
                    )
                  ], title: Text('本人・年齢確認後でないとトークできません。本人・年齢確認画面に移動しますか？'));
                });
          }
        },
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:machupichu/services/database.dart';

class BlockScreen extends StatefulWidget {
  String name, chatRoomId, uid;
  BlockScreen(this.name, this.chatRoomId, this.uid);

  @override
  State<BlockScreen> createState() => _BlockScreenState();
}

class _BlockScreenState extends State<BlockScreen> {
  late bool mute = false;
  late bool block = false;

  doThisOnLaunch() async {
    print(widget.uid);
    final a = FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(widget.chatRoomId);
    try {
      a.get().then((docSnapshot) => {
            this.mute = docSnapshot.get('${widget.uid}mute'),
            this.block = docSnapshot.get('${widget.uid}block'),
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          '${widget.name}',
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
                    DatabaseService(widget.uid)
                        .muteChatRoom(widget.chatRoomId, !mute);
                    setState(() {
                      this.mute = !mute;
                    });
                  },
                  child: Icon(
                    mute ? Icons.volume_off_sharp : Icons.volume_up_outlined,
                    size: 80,
                    color: Colors.black,
                  ),
                ),
                Text(
                  this.mute ? '通知オン' : '通知オフ',
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
                                        DatabaseService(widget.uid)
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
                            DatabaseService(widget.uid)
                                .kaijoChatRoom(widget.chatRoomId);
                            this.block = !block;
                          });
                  },
                  child: Icon(
                    this.block ? Icons.do_not_disturb_on : Icons.block,
                    size: 80,
                    color: Colors.black,
                  ),
                ),
                Text(
                  this.block ? 'ブロック解除' : 'ブロック',
                  style: TextStyle(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

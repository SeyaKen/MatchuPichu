import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:machupichu/chat/block.dart';
import 'package:machupichu/chat/chatImage.dart';
import 'package:machupichu/services/database.dart';
import 'package:random_string/random_string.dart';

class chatScreen extends StatefulWidget {
  final String chatWithUsername, name, chatRoomId, youName, aitenoURL;
  chatScreen(this.chatWithUsername, this.name, this.chatRoomId, this.youName,
      this.aitenoURL);

  @override
  _chatScreenState createState() => _chatScreenState(chatRoomId, aitenoURL);
}

class _chatScreenState extends State<chatScreen> with WidgetsBindingObserver {
  String chatRoomId;
  _chatScreenState(this.chatRoomId, this.aitenoURL);
  Stream<QuerySnapshot<Object?>>? messageStream;
  late String messageId = '';
  TextEditingController messageTextEdittingController = TextEditingController();
  String imageurl = '';
  int m = 0;
  bool? nyuusitucheck;
  late final a;
  String aitenoURL;

  // didChangeAppLifecycleStateが状態の変更があった時に呼び出されるメソッドです
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    final isBackground = state == AppLifecycleState.paused;
    final resumed = state == AppLifecycleState.resumed;
    if (isBackground || state == AppLifecycleState.detached) {
      print('バックグラウンド');
      DatabaseService(widget.name).minusNyuusitu(chatRoomId, widget.name);
      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatRoomId)
          .update({'${widget.name}midoku': 0});
    } else if (resumed) {
      print('再開');
      DatabaseService(widget.name).updateLastNyuusitu(chatRoomId, widget.name);
    }
  }

  getMyInfoFromSharedPreference() async {
    messageStream =
        await DatabaseService(widget.name).getChatRoomMessages(chatRoomId);
    chatRoomId = getChatRoomIdByUsernames(widget.chatWithUsername, widget.name);
  }

  getChatRoomIdByUsernames(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  getAndSetMessages() async {
    messageStream =
        await DatabaseService(widget.name).getChatRoomMessages(chatRoomId);
    setState(() {});
  }

  doThisOnLaunch() async {
    getAndSetMessages();
    this.a = FirebaseFirestore.instance.collection("chatrooms").doc(chatRoomId);
    try {
      a.get().then((docSnapshot) => {
            this.m = docSnapshot.get('${widget.chatWithUsername}midoku'),
            this.nyuusitucheck =
                docSnapshot.get('${widget.chatWithUsername}nyuusitu'),
            setState(() {})
          });
    } catch (e) {
      this.m = 0;
      this.nyuusitucheck = false;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    doThisOnLaunch();
    DatabaseService(widget.name).updateLastNyuusitu(chatRoomId, widget.name);
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  addMessage(bool sendClicked) async {
    try {
      this.a.get().then((docSnapshot) => {
            this.m = docSnapshot.get('${widget.chatWithUsername}midoku'),
            this.nyuusitucheck =
                docSnapshot.get('${widget.chatWithUsername}nyuusitu'),
            setState(() {}),
          });
    } catch (e) {
      this.m = 0;
      this.nyuusitucheck = false;
      setState(() {});
    }
    if (messageTextEdittingController.text != '' && imageurl == '') {
      String message = messageTextEdittingController.text;

      var lastMessageTs = DateTime.now();

      QuerySnapshot I = await DatabaseService(widget.name)
          .getUserInfo(widget.chatWithUsername, widget.name);
      QuerySnapshot You = await DatabaseService(widget.name)
          .getUserInfo(widget.name, widget.chatWithUsername);

      String iName = I.docs[0]["name"];
      String youName = You.docs[0]['name'];

      this.m = this.m + 1;

      Map<String, dynamic> messageInfoMap = {
        'message': message,
        'sendBy': widget.name,
        'ts': lastMessageTs,
        'sendTo': widget.chatWithUsername,
        'senderName': iName,
        'chatRoomId': chatRoomId,
      };

      if (messageId == '') {
        messageId = randomAlphaNumeric(12);
      }

      DatabaseService(widget.name)
          .addMessage(chatRoomId, messageId, messageInfoMap)
          .then((value) {
        Map<String, dynamic> lastMessageInfoMap = {
          "users": [widget.name,  widget.chatWithUsername],
          "lastMessage": message,
          "lastMessageSendTs": lastMessageTs,
          "lastMessageSendBy": widget.name,
          "${widget.name}I": iName,
          "${widget.chatWithUsername}You": youName,
          "sendBy": widget.name,
          "${widget.name}midoku": 0,
          "${widget.chatWithUsername}midoku": this.nyuusitucheck! ? 0 : this.m,
        };
        DatabaseService(widget.name)
            .updateLastMessageSend(chatRoomId, lastMessageInfoMap);
        if (sendClicked) {
          // remove the text in the message input field
          messageTextEdittingController.text = '';

          // make message id blank to get regereted on next message send
          messageId = '';
        }
      });
    } else if (imageurl != '') {
      String message = imageurl;

      var lastMessageTs = DateTime.now();

      if (messageId == '') {
        messageId = randomAlphaNumeric(12);
      }

      QuerySnapshot I = await DatabaseService(widget.name)
          .getUserInfo(widget.chatWithUsername, widget.name);
      QuerySnapshot You = await DatabaseService(widget.name)
          .getUserInfo(widget.name, widget.chatWithUsername);
      String iName = I.docs[0]["name"];
      String youName = You.docs[0]['name'];

      this.m = this.m + 1;

      Map<String, dynamic> messageInfoMap = {
        'message': message,
        'sendBy': widget.name,
        'ts': lastMessageTs,
        'sendTo': widget.chatWithUsername,
        'senderName': iName,
        'chatRoomId': chatRoomId,
      };

      DatabaseService(widget.name)
          .addMessage(chatRoomId, messageId, messageInfoMap)
          .then((value) {
        Map<String, dynamic> lastMessageInfoMap = {
          "lastMessage": message,
          "lastMessageSendTs": lastMessageTs,
          "lastMessageSendBy": widget.name,
          "${widget.name}I": iName,
          "${widget.chatWithUsername}You": youName,
          "sendBy": widget.name,
          "${widget.name}midoku": 0,
          "${widget.chatWithUsername}midoku": this.nyuusitucheck! ? 0 : this.m,
        };
        DatabaseService(widget.name)
            .updateLastMessageSend(chatRoomId, lastMessageInfoMap);
        if (sendClicked) {
          // remove the text in the message input field
          imageurl = '';

          // make message id blank to get regereted on next message send
          messageId = '';
        }
      });
    }
  }

  Widget chatMessages() {
    return StreamBuilder<QuerySnapshot>(
        stream: messageStream,
        builder: (context, snapshot) {
          print(snapshot.error);
          return snapshot.hasData
              ? ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  reverse: true,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data!.docs[index];
                    return chatMessageTile(
                      ds['message'],
                      widget.name == ds['sendBy'],
                      ds['ts'],
                    );
                  },
                )
              : Center(child: CircularProgressIndicator());
        });
  }

  Widget chatMessageTile(String message, bool sendByMe, Timestamp ts) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 5),
        !sendByMe
            ? Container(
                height: 40,
                width: 40,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100000.0),
                  child: Image.network(
                    aitenoURL,
                    fit: BoxFit.cover,
                  ),
                ),
              )
            : Container(),
        Flexible(
          child: message.contains('firebasestorage.googleapis.com')
              ? Row(
                  mainAxisAlignment: sendByMe
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    sendByMe
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 13),
                            child: Text(
                              '${ts.toDate().toString().substring(10, 16)}',
                              style: TextStyle(fontSize: 12),
                            ),
                          )
                        : Container(),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (_, __, ___) => chatImage(message),
                            transitionDuration: Duration(seconds: 0),
                          ),
                        );
                      },
                      child: Container(
                        constraints: BoxConstraints(
                            minWidth: 100,
                            maxWidth: MediaQuery.of(context).size.width * 0.55),
                        margin: EdgeInsets.only(right: 5, left: 5, bottom: 5),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(13.0),
                          child: Image.network(
                            message,
                          ),
                        ),
                      ),
                    ),
                    !sendByMe
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 13),
                            child: Text(
                              '${ts.toDate().toString().substring(10, 16)}',
                              style: TextStyle(fontSize: 12),
                            ),
                          )
                        : Container(),
                  ],
                )
              : Row(
                  mainAxisAlignment: sendByMe
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    sendByMe
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 13),
                            child: Text(
                              '${ts.toDate().toString().substring(10, 16)}',
                              style: TextStyle(fontSize: 12),
                            ),
                          )
                        : Container(),
                    Flexible(
                      child: Container(
                        margin: EdgeInsets.only(right: 5, left: 5, bottom: 5),
                        decoration: BoxDecoration(
                          border: sendByMe
                              ? null
                              : Border.all(width: 0.5, color: Colors.grey),
                          borderRadius:
                              BorderRadius.all(Radius.circular(1000000)),
                          color: sendByMe ? Colors.grey[300] : Colors.grey[200],
                        ),
                        padding: EdgeInsets.all(16),
                        child: Text(
                          message,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    !sendByMe
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 13),
                            child: Text(
                              '${ts.toDate().toString().substring(10, 16)}',
                              style: TextStyle(fontSize: 12),
                            ),
                          )
                        : Container(),
                  ],
                ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      FirebaseFirestore.instance
                          .collection("chatrooms")
                          .doc(widget.chatRoomId)
                          .update({'${widget.name}midoku': 0});
                      DatabaseService(widget.name)
                          .minusNyuusitu(chatRoomId, widget.name);
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 30,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    '${widget.youName}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return BlockScreen(
                            widget.youName, widget.chatRoomId, widget.name);
                      },
                    ),
                  );
                },
                child: Icon(
                  Icons.more_horiz,
                  size: 40,
                  color: Colors.black,
                ),
              ),
            ],
          )),
      body: GestureDetector(
        onTap: () {
          final FocusScopeNode currentScope = FocusScope.of(context);
          if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
            FocusManager.instance.primaryFocus!.unfocus();
          }
        },
        child: Container(
          padding: EdgeInsets.only(top: 8, bottom: 8),
          color: Colors.white,
          child: SafeArea(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Flexible(
                      child: SingleChildScrollView(
                          reverse: true,
                          physics: ScrollPhysics(),
                          child: chatMessages())),
                  SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () async {
                            imageurl = await DatabaseService(widget.name)
                                .chatUpdateCamera(
                                    randomAlphaNumeric(12), context);
                            addMessage(true);
                          },
                          child: Icon(
                            Icons.camera_alt,
                            size: 35,
                            color: Colors.grey,
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            imageurl = await DatabaseService(widget.name)
                                .chatUpdateImage(randomAlphaNumeric(12));
                            addMessage(true);
                          },
                          child: Icon(
                            Icons.image,
                            size: 35,
                            color: Colors.grey,
                          ),
                        ),
                        Flexible(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.65,
                            alignment: Alignment.bottomCenter,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              color: Colors.grey[200],
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: TextField(
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                                controller: messageTextEdittingController,
                                decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 0,
                                        vertical:
                                            MediaQuery.of(context).size.width *
                                                0.02),
                                    border: InputBorder.none,
                                    hintText: 'メッセージを入力してください',
                                    hintStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                    ))),
                          ),
                        ),
                        InkWell(
                            onTap: () {
                              final a = FirebaseFirestore.instance
                                  .collection("chatrooms")
                                  .doc(chatRoomId);
                              try {
                                a.get().then((docSnapshot) => {
                                      this.m = docSnapshot.get(
                                          '${widget.chatWithUsername}midoku'),
                                    });
                              } catch (e) {
                                this.m = 0;
                              }
                              addMessage(true);
                            },
                            child: Text(
                              '送信',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Colors.blue,
                              ),
                            )),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

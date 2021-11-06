import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:machupichu/chat/chatLists.dart';
import 'package:machupichu/home/home_list_page.dart';
import 'package:machupichu/profile/profile_page.dart';
import 'package:machupichu/services/database.dart';
import 'package:machupichu/telephone/telephone.dart';

class MainPage extends StatefulWidget {
  int currenttab;
  String myUserUid, grade, major;
  int height1, height2;
  MainPage(this.currenttab, this.myUserUid, this.grade, this.major,
      this.height1, this.height2);

  @override
  _MainPageState createState() => _MainPageState(currenttab);
}

class _MainPageState extends State<MainPage> {
  int currenttab;
  _MainPageState(this.currenttab);
  Stream<QuerySnapshot<Object?>>? notificationStream;
  String? myUserUid;

  getMyUserUid() async {
    this.myUserUid = await FirebaseAuth.instance.currentUser!.uid;
    setState(() {});
  }

  getChatRooms() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    notificationStream = await DatabaseService(uid).getNotifications();
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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: notificationStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? Scaffold(
                  bottomNavigationBar: Container(
                    child: BottomNavigationBar(
                      onTap: (index) {
                        setState(() {
                          currenttab = index;
                        });
                      },
                      currentIndex: currenttab,
                      type: BottomNavigationBarType.fixed,
                      selectedItemColor: Color(0xFFed1b24).withOpacity(0.77),
                      backgroundColor: Colors.white,
                      unselectedItemColor: Colors.grey,
                      items: <BottomNavigationBarItem>[
                        BottomNavigationBarItem(
                          icon: Icon(
                            Icons.home,
                            size: 30,
                          ),
                          label: 'ホーム',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(
                            Icons.call,
                            size: 30,
                          ),
                          label: '電話する',
                        ),
                        BottomNavigationBarItem(
                          icon: Container(
                            width: MediaQuery.of(context).size.width * 0.12,
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Icon(
                                    Icons.chat,
                                    size: 30,
                                  ),
                                ),
                                snapshot.data!.docs[0]['notifications'] != 0
                                    ? Positioned(
                                        right: 0,
                                        top: -2,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.white, width: 2),
                                            borderRadius:
                                                BorderRadius.circular(30000000),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(30000000),
                                            child: Container(
                                              height: 19,
                                              width: 19,
                                              color: Color(0xFFed1b24),
                                              child: Center(
                                                child: Text(
                                                  snapshot.data!
                                                      .docs[0]['notifications']
                                                      .toString(),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : SizedBox(width: 0),
                              ],
                            ),
                          ),
                          label: 'メッセージ',
                        ),
                        BottomNavigationBarItem(
                          icon: Container(
                            width: MediaQuery.of(context).size.width * 0.12,
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.account_circle,
                                    size: 30,
                                  ),
                                ),
                                snapshot.data!.docs[0]['osirase'] || snapshot.data!.docs[0]['kakuninbool'] ? Positioned(
                                        right: 5,
                                        top: 0,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.white, width: 2),
                                            borderRadius:
                                                BorderRadius.circular(30000000),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(30000000),
                                            child: Container(
                                              height: 10,
                                              width: 10,
                                              color: Color(0xFFed1b24),
                                              child: Container(),
                                            ),
                                          ),
                                        ),
                                      ) : Container(),
                              ],
                            ),
                          ),
                          label: 'プロフィール',
                        ),
                      ],
                    ),
                  ),
                  body: IndexedStack(
                    children: [
                      HomePageList(widget.myUserUid, widget.grade, widget.major,
                          widget.height1, widget.height2),
                      Telephone(),
                      chatLists(),
                      ProfilePage(),
                    ],
                    index: currenttab,
                  ),
                )
              : Scaffold(body: Center(child: CircularProgressIndicator()));
        });
  }
}

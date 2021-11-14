import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:machupichu/osirase/osirase.dart';
import 'package:machupichu/profile/profile_edit.dart';
import 'package:machupichu/services/database.dart';
import 'package:machupichu/settings/settings_list.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Stream<QuerySnapshot<Object?>>? profileListsStream;
  DocumentSnapshot? ds;
  late final CollectionReference brewCollection;

  String uid = FirebaseAuth.instance.currentUser!.uid;

  getHomeLists() async {
    profileListsStream = await DatabaseService(uid).fetchImage();
    setState(() {});
  }

  onScreenLoaded() async {
    getHomeLists();
    this.brewCollection = FirebaseFirestore.instance.collection('user');
  }

  @override
  void initState() {
    onScreenLoaded();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: profileListsStream,
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            this.ds = snapshot.data!.docs[0];
          }
          return snapshot.hasData
              ? Scaffold(
                  appBar: AppBar(
                      automaticallyImplyLeading: false,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      toolbarHeight: 60,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Stack(
                            children: [
                              InkWell(
                                onTap: () async {
                                  await FirebaseFirestore.instance.collection('user').doc(uid).update({'osirase': false});
                                  Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (_, __, ___) =>
                                            OsiraseList(),
                                        transitionDuration:
                                            Duration(seconds: 0),
                                      ));
                                },
                                child: Icon(
                                  Icons.notifications,
                                  size: 35,
                                  color: Colors.black,
                                ),
                              ),
                              ds!['osirase']
                                  ? Positioned(
                                      right: 3,
                                      top: 3,
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
                                    )
                                  : Container(),
                            ],
                          ),
                          SizedBox(width: 15),
                          Stack(
                            children: [
                              InkWell(
                                onTap: () async{
                                  await FirebaseFirestore.instance.collection('user').doc(uid).update({'kakuninbool': false});
                                  Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (_, __, ___) => SettingList(),
                                        transitionDuration: Duration(seconds: 0),
                                      ));
                                },
                                child: Icon(
                                  Icons.settings,
                                  size: 35,
                                  color: Colors.black,
                                ),
                              ),
                              ds!['kakuninbool']
                                  ? Positioned(
                                      right: 0,
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
                                    )
                                  : Container(),
                            ],
                          ),
                        ],
                      )),
                  resizeToAvoidBottomInset: false,
                  body: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.2,
                            width: MediaQuery.of(context).size.width * 0.85,
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(150.0),
                                  child: SizedBox(
                                    width: 110,
                                    height: 110,
                                    child: Image.network(
                                      ds!['imageURL'],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.05),
                                Expanded(
                                  child: Text(
                                    ds!['name'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.035),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.85,
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
                                width: MediaQuery.of(context).size.width * 0.85,
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
                                          ]),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height *
                                      0.02),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.85,
                                child: Text(
                                  'ひとこと',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.85,
                                child: Text(
                                  ds!['hitokoto'],
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height *
                                      0.02),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.85,
                                child: Text(
                                  '自己紹介',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.85,
                                child: Text(
                                  ds!['ex'],
                                ),
                              ),
                            ],
                          ),
                        ]),
                        Column(
                          children: [
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (_, __, ___) =>
                                            ProfileEdit(),
                                        transitionDuration:
                                            Duration(seconds: 0),
                                      ));
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'プロフィールを編集する',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Color(0xFFed1b24)
                                              .withOpacity(0.77)),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 30,
                                      color:
                                          Color(0xFFed1b24).withOpacity(0.77),
                                    ),
                                  ],
                                )),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              : Center(child: CircularProgressIndicator());
        });
  }
}

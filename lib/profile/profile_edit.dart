import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:machupichu/edit/gradeedit.dart';
import 'package:machupichu/edit/majoredit.dart';
import 'package:machupichu/edit/nameedit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:machupichu/services/editDatabase.dart';
import 'package:machupichu/edit/exedit.dart';
import 'package:machupichu/edit/heightedit.dart';
import 'package:machupichu/edit/hitokotoedit.dart';

class ProfileEdit extends StatefulWidget {
  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  final picker = ImagePicker();
  Stream<QuerySnapshot<Object?>>? profileListsStream;
  DocumentSnapshot? ds;

  String uid = FirebaseAuth.instance.currentUser!.uid;

  getHomeLists() async {
    profileListsStream = await editService(uid).fetchImage();
    setState(() {});
  }

  onScreenLoaded() async {
    getHomeLists();
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
                  backgroundColor: Colors.white,
                  extendBodyBehindAppBar: true,
                  appBar: AppBar(
                      backgroundColor: Colors.transparent,
                      automaticallyImplyLeading: false,
                      elevation: 0,
                      title: Row(
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
                        ],
                      )),
                  body: SingleChildScrollView(
                    child: SafeArea(
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(1000),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.8,
                                  height: MediaQuery.of(context).size.width * 0.8,
                                  child: InkWell(
                                    onTap: () async {
                                      await editService(uid).updateImage();
                                    },
                                    child: ds!['imageURL'] != null
                                        ? Image.network(
                                            ds!['imageURL'],
                                            fit: BoxFit.cover,
                                          )
                                        : Container(color: Colors.grey),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 30,
                                child: ElevatedButton(
                                    onPressed: () async {
                                      await editService(uid).updateImage();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        '写真を編集する',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                          color: Color(0xFFed1b24)
                                              .withOpacity(0.77),
                                        ),
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10000.0),
                                        ))),
                              ),
                            ]),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.035),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (_, __, ___) =>
                                          NameEdit(ds!['name']),
                                      transitionDuration: Duration(seconds: 0),
                                    ));
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.width * 0.1,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'ニックネーム',
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                      Flexible(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                ds!['name'],
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: Color(0xFFed1b24)
                                                      .withOpacity(0.77),
                                                ),
                                              ),
                                            ),
                                            Icon(
                                              Icons.arrow_forward_ios_rounded,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (_, __, ___) =>
                                          GradeEdit(ds!['grade']),
                                      transitionDuration: Duration(seconds: 0),
                                    ));
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.width * 0.1,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '学年',
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            ds!['grade'],
                                            style: TextStyle(
                                              color: Color(0xFFed1b24)
                                                  .withOpacity(0.77),
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios_rounded,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (_, __, ___) =>
                                          MajorEdit(ds!['major']),
                                      transitionDuration: Duration(seconds: 0),
                                    ));
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.width * 0.1,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '学部',
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            ds!['major'],
                                            style: TextStyle(
                                              color: Color(0xFFed1b24)
                                                  .withOpacity(0.77),
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios_rounded,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (_, __, ___) =>
                                          HeightEdit(ds!['height']),
                                      transitionDuration: Duration(seconds: 0),
                                    ));
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.width * 0.1,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '身長',
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            ds!['height'].toString() + 'cm',
                                            style: TextStyle(
                                              color: Color(0xFFed1b24)
                                                  .withOpacity(0.77),
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios_rounded,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.035),
                                      Text(
                                        'ひとこと',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.005),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (_, __, ___) =>
                                              HitokotoEdit(ds!['hitokoto']),
                                          transitionDuration:
                                              Duration(seconds: 0),
                                        ));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            ds!['hitokoto'],
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios_rounded,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.035),
                                      Text(
                                        '自己紹介',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.005),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (_, __, ___) =>
                                              ExEdit(ds!['ex']),
                                          transitionDuration:
                                              Duration(seconds: 0),
                                        ));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            ds!['ex'],
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios_rounded,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height *
                                        0.035),
                              ],
                            ),
                          ],
                        ),
                      ],
                    )),
                  ),
                )
              : Center(child: CircularProgressIndicator());
        });
  }
}

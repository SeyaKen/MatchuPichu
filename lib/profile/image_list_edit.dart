import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:machupichu/services/database.dart';
import 'package:machupichu/services/editDatabase.dart';

class ImageListEdit extends StatefulWidget {
  const ImageListEdit({Key? key}) : super(key: key);

  @override
  _ImageListEditState createState() => _ImageListEditState();
}

class _ImageListEditState extends State<ImageListEdit> {
  final picker = ImagePicker();
  Stream<QuerySnapshot<Object?>>? profileListsStream;
  DocumentSnapshot? ds;
  int? listcount;

  String uid = FirebaseAuth.instance.currentUser!.uid;

  getHomeLists() async {
    profileListsStream = await editService(uid).fetchImage();
    setState(() {});
  }

  @override
  void initState() {
    getHomeLists();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
              toolbarHeight: 70,
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
                  Flexible(
                    child: Text(
                      'プロフィール写真を編集',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 30,
                    color: Colors.white,
                  ),
                ],
              )),
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Stack(
              alignment: Alignment.center,
              children:[
                Column(
                  children: [
                    SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Text('画像を長押しすることで、画像を変更、削除することができます。')
                    ),
                    SizedBox(height: 20),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: StreamBuilder<QuerySnapshot>(
                            stream: profileListsStream,
                            builder: (context, snapshot) {
                              if (snapshot.data != null) {
                                this.ds = snapshot.data!.docs[0];
                                print(snapshot.error);
                                ds!['imageURL'].length % 2 == 0
                                    ? this.listcount =
                                        (ds!['imageURL'].length / 2 + 1).toInt()
                                    : this.listcount =
                                        ((ds!['imageURL'].length - 1) / 2).toInt() +
                                            1;
                              }
                    
                              return snapshot.hasData && this.listcount != null
                                  ? ListView.builder(
                                      itemCount: this.listcount,
                                      itemBuilder: (BuildContext context, int i) {
                                        try {
                                          return Container(
                                            child: InkWell(
                                              onTap: () {},
                                              child: Column(
                                                children: [
                                                  SizedBox(height: 20),
                                                  i != 0 &&
                                                          i * 2 - 1 !=
                                                              ds!['imageURL'].length -
                                                                  1
                                                      ? Center(
                                                          child: Container(
                                                            width:
                                                                MediaQuery.of(context)
                                                                        .size
                                                                        .width *
                                                                    0.8,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Stack(
                                                                  children: [
                                                                    Container(
                                                                      width: MediaQuery.of(
                                                                                  context)
                                                                              .size
                                                                              .width *
                                                                          0.35,
                                                                      height: MediaQuery.of(
                                                                                  context)
                                                                              .size
                                                                              .width *
                                                                          0.35,
                                                                      child:
                                                                          ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius
                                                                                .circular(
                                                                                    5),
                                                                        child: Image
                                                                            .network(
                                                                          ds!['imageURL']
                                                                              [i * 2 -
                                                                                  1],
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Positioned(
                                                                      top: 10,
                                                                      right: 10,
                                                                      child: InkWell(
                                                                        onTap:
                                                                            () async {
                                                                          DatabaseService(
                                                                                  uid)
                                                                              .profilePictureControll(
                                                                                  ds,
                                                                                  i * 2 -
                                                                                      1);
                                                                        },
                                                                        child:
                                                                            ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.all(
                                                                                  Radius.circular(1000)),
                                                                          child:
                                                                              Container(
                                                                            width: 30,
                                                                            height:
                                                                                30,
                                                                            color: Colors
                                                                                .white
                                                                                .withOpacity(
                                                                                    0.5),
                                                                            child:
                                                                                Icon(
                                                                              Icons
                                                                                  .clear_rounded,
                                                                              size:
                                                                                  25,
                                                                              color: Color(0xFFed1b24)
                                                                                  .withOpacity(0.77),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                Stack(
                                                                  children: [
                                                                    Container(
                                                                      width: MediaQuery.of(
                                                                                  context)
                                                                              .size
                                                                              .width *
                                                                          0.35,
                                                                      height: MediaQuery.of(
                                                                                  context)
                                                                              .size
                                                                              .width *
                                                                          0.35,
                                                                      child:
                                                                          ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius
                                                                                .circular(
                                                                                    5),
                                                                        child: Image
                                                                            .network(
                                                                          ds!['imageURL']
                                                                              [i * 2],
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Positioned(
                                                                      top: 10,
                                                                      right: 10,
                                                                      child: InkWell(
                                                                        onTap:
                                                                            () async {
                                                                          DatabaseService(
                                                                                  uid)
                                                                              .profilePictureControll(
                                                                                  ds,
                                                                                  i * 2);
                                                                        },
                                                                        child:
                                                                            ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.all(
                                                                                  Radius.circular(1000)),
                                                                          child:
                                                                              Container(
                                                                            width: 30,
                                                                            height:
                                                                                30,
                                                                            color: Colors
                                                                                .white
                                                                                .withOpacity(
                                                                                    0.5),
                                                                            child:
                                                                                Icon(
                                                                              Icons
                                                                                  .clear_rounded,
                                                                              size:
                                                                                  25,
                                                                              color: Color(0xFFed1b24)
                                                                                  .withOpacity(0.77),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      : i != 0 &&
                                                              i * 2 - 1 ==
                                                                  ds!['imageURL']
                                                                          .length -
                                                                      1
                                                          ? Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.8,
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Stack(
                                                                    children: [
                                                                      Container(
                                                                        width: MediaQuery.of(
                                                                                    context)
                                                                                .size
                                                                                .width *
                                                                            0.35,
                                                                        height: MediaQuery.of(
                                                                                    context)
                                                                                .size
                                                                                .width *
                                                                            0.35,
                                                                        child:
                                                                            ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius
                                                                                  .circular(5),
                                                                          child: Image
                                                                              .network(
                                                                            ds!['imageURL']
                                                                                [
                                                                                i * 2 -
                                                                                    1],
                                                                            fit: BoxFit
                                                                                .cover,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Positioned(
                                                                        top: 10,
                                                                        right: 10,
                                                                        child:
                                                                            InkWell(
                                                                          onTap:
                                                                              () async {
                                                                            DatabaseService(uid).profilePictureControll(
                                                                                ds,
                                                                                i * 2 -
                                                                                    1);
                                                                          },
                                                                          child:
                                                                              ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.all(
                                                                                    Radius.circular(1000)),
                                                                            child:
                                                                                Container(
                                                                              width:
                                                                                  30,
                                                                              height:
                                                                                  30,
                                                                              color: Colors
                                                                                  .white
                                                                                  .withOpacity(0.5),
                                                                              child:
                                                                                  Icon(
                                                                                Icons
                                                                                    .clear_rounded,
                                                                                size:
                                                                                    25,
                                                                                color:
                                                                                    Color(0xFFed1b24).withOpacity(0.77),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          : Stack(
                                                              children: [
                                                                CupertinoContextMenu(
                                                                  actions: [
                                                                    CupertinoContextMenuAction(
                                                                      child: const Text(
                                                                          '写真を変更する'),
                                                                      onPressed: () {
                                                                        DatabaseService(
                                                                                uid)
                                                                            .profilePictureUpdate(
                                                                                ds, i)
                                                                            .then(
                                                                                (val) {
                                                                          Navigator.pop(
                                                                              context);
                                                                        });
                                                                      },
                                                                    ),
                                                                    CupertinoContextMenuAction(
                                                                      child:
                                                                          const Text(
                                                                              'キャンセル'),
                                                                      onPressed: () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                    ),
                                                                  ],
                                                                  child: Container(
                                                                    width: MediaQuery.of(
                                                                                context)
                                                                            .size
                                                                            .width *
                                                                        0.8,
                                                                    height: MediaQuery.of(
                                                                                context)
                                                                            .size
                                                                            .width *
                                                                        0.8,
                                                                    child: ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .circular(
                                                                                  5),
                                                                      child: Image
                                                                          .network(
                                                                        ds!['imageURL']
                                                                            [i],
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                ],
                                              ),
                                            ),
                                          );
                                        } catch (e) {
                                          return Center();
                                        }
                                      })
                                  : Center();
                            }),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 50,
                  child: ElevatedButton(
                      onPressed: () async {
                        try {
                          DatabaseService(uid).profilePictureAdd();
                        } catch (e) {
                          print(e.toString());
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '写真を追加する',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: Color(0xFFed1b24).withOpacity(0.77),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10000.0),
                          ))),
                ),
              ],
            ),
          )),
    );
  }
}

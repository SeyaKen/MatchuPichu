import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:machupichu/edit/gradeedit.dart';
import 'package:machupichu/edit/majoredit.dart';
import 'package:machupichu/edit/nameedit.dart';
import 'package:machupichu/services/editDatabase.dart';
import 'package:machupichu/edit/exedit.dart';
import 'package:machupichu/edit/heightedit.dart';
import 'package:machupichu/edit/hitokotoedit.dart';
import 'package:machupichu/profile/image_list_edit.dart';

class ProfileEdit extends StatefulWidget {
  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
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
                              CarouselWithDotsPage(ds!['imageURL']),
                              Positioned(
                                bottom: 40,
                                child: ElevatedButton(
                                    onPressed: () async {
                                      Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (_, __, ___) =>
                                          ImageListEdit(),
                                      transitionDuration: Duration(seconds: 0),
                                    ));
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

class CarouselWithDotsPage extends StatefulWidget {
  List<dynamic> imgList;
  CarouselWithDotsPage(this.imgList);

  @override
  _CarouselWithDotsPageState createState() => _CarouselWithDotsPageState();
}

class _CarouselWithDotsPageState extends State<CarouselWithDotsPage> {
  int _current = 0;
  @override
  Widget build(BuildContext context) {
    final List<Widget> imageSliders = widget.imgList
        .map(
          (item) => ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              height: MediaQuery.of(context).size.width * 0.8,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Image.network(
                item,
                fit: BoxFit.cover,
              ),
            ),
          ),
        )
        .toList();
    return Column(
      children: [
        CarouselSlider(
          items: imageSliders,
          options: CarouselOptions(
              height: MediaQuery.of(context).size.width * 0.8,
              autoPlay: false,
              enlargeCenterPage: true,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.imgList.map((url) {
            int index = widget.imgList.indexOf(url);
            return Container(
              width: 8,
              height: 8,
              margin: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 3,
              ),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _current == index
                    ? Color.fromRGBO(0, 0, 0, 0.9)
                    : Color.fromRGBO(0, 0, 0, 0.4),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

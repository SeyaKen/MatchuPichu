import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:machupichu/home/home_list_model.dart';
import 'package:machupichu/chat/home_detailpage.dart';
import 'package:machupichu/search/memberSearch.dart';

class HomePageList extends StatefulWidget {
  String myUserUid, grade, major;
  int height1, height2;
  HomePageList(
      this.myUserUid, this.grade, this.major, this.height1, this.height2);
  @override
  State<HomePageList> createState() => _HomePageListState();
}

class _HomePageListState extends State<HomePageList> {
  Stream<QuerySnapshot<Object?>>? homeListsStream, searchListsStream;
  bool _isLoading = false;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  final ScrollController _scrollController = ScrollController();
  int _currentMax = 100;

  getHomeLists() async {
    try {
      searchListsStream = await HomeListModel(uid).getSearchInfo(
          widget.myUserUid,
          widget.grade,
          widget.major,
          widget.height1,
          widget.height2);
    } catch (e) {
      print('検索していない状態');
      print(e);
      searchListsStream = null;
      homeListsStream = await HomeListModel(uid).fetchImages(100);
    }
    setState(() {});
    // setStateがよばれるたびにrebuildされる
  }

  onScreenLoaded() async {
    getHomeLists();
  }

  _getMoreData() async {
    _currentMax = _currentMax + 100;
    print(_currentMax);
    homeListsStream = await HomeListModel(uid).fetchImages(_currentMax);
    // UIを読み込み直す
    setState(() {});
  }

  @override
  void initState() {
    onScreenLoaded();
    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        _isLoading = true;
      });
      setState(() {
        _isLoading = false;
      });
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget homeLists() {
      return StreamBuilder<QuerySnapshot>(
        stream: searchListsStream == null ? homeListsStream : searchListsStream,
        builder: (context, snapshot) {
          print('home_list_pageのsnapshotのエラー');
          print(snapshot.error);
          return snapshot.hasData && snapshot.data!.docs.length != 0
              ? GridView.count(
                  controller: _scrollController,
                  crossAxisCount: 2,
                  childAspectRatio: 0.85,
                  children: List.generate(snapshot.data!.docs.length + 2, (i) {
                    int check = i % 2;
                    try {
                      DocumentSnapshot ds = snapshot.data!.docs[i];
                      return Center(
                        child: Container(
                          padding: EdgeInsets.only(
                              left: check == 0 ? 5 : 0,
                              right: check == 1 ? 5 : 0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (_, __, ___) =>
                                        HomeDetail(ds['uid'], uid),
                                    transitionDuration: Duration(seconds: 0),
                                  ));
                            },
                            child: Column(
                              children: [
                                ds['imageURL'].isNotEmpty
                                    ? Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.43,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.43,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          child: Image.network(
                                            ds['imageURL'],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )
                                    : Stack(
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.43,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.43,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.only(left: 5),
                                    width: MediaQuery.of(context).size.width *
                                        0.43,
                                    height: MediaQuery.of(context).size.width *
                                        0.43,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              ds['grade'],
                                              style: TextStyle(
                                                color: Color(0xFFed1b24)
                                                    .withOpacity(0.77),
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            SizedBox(
                                              width: 120,
                                              child: Text(
                                                ds['major'],
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: Color(0xFFed1b24)
                                                      .withOpacity(0.77),
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Flexible(
                                              child: Container(
                                                child: Text(
                                                  ds['hitokoto'],
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    } catch (e) {
                      return CupertinoActivityIndicator();
                    }
                  }),
                )
              : searchListsStream == null
                  ? Center(child: CircularProgressIndicator())
                  : Stack(
                      children: [
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Icon(Icons.search),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    '検索条件に合うお相手がいません',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.all(25.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.85,
                              child: FloatingActionButton.extended(
                                elevation: 0,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (_, __, ___) =>
                                            memberSearch(),
                                        transitionDuration:
                                            Duration(seconds: 0),
                                      ));
                                },
                                label: Text(
                                  '検索条件を設定する',
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                backgroundColor:
                                    Color(0xFFed1b24).withOpacity(0.77),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
        },
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          toolbarHeight: 88,
          backgroundColor: Color(0xFFed1b24).withOpacity(0.77),
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text(
                          'さがす',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  height: MediaQuery.of(context).size.width * 0.1,
                  width: MediaQuery.of(context).size.width * 0.8,
                  alignment: Alignment.bottomCenter,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    color: Colors.grey[300],
                  ),
                  child: Stack(
                    children: [
                      TextField(
                          textAlignVertical: TextAlignVertical.center,
                          style: TextStyle(
                            fontSize: 15,
                          ),
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              isDense: true,
                              border: InputBorder.none,
                              hintText: '検索条件を設定する',
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ))),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (_, __, ___) => memberSearch(),
                                transitionDuration: Duration(seconds: 0),
                              ));
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.width * 0.1,
                          width: MediaQuery.of(context).size.width * 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          )),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: homeLists(),
            ),
    );
  }
}

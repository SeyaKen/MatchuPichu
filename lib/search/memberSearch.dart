import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:machupichu/main_page.dart';

class memberSearch extends StatefulWidget {
  const memberSearch({Key? key}) : super(key: key);

  @override
  _memberSearchState createState() => _memberSearchState();
}

class _memberSearchState extends State<memberSearch> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  final items = [
    'こだわらない',
    '1年',
    '2年',
    '3年',
    '4年',
  ];

  final major = [
    'こだわらない',
    '法学部',
    '経済学部',
    '商学部',
    '文学部',
    '総合政策学部',
    '国際経営学部',
    '国際情報学部',
    '理工学部',
  ];

  final height1 = List<int>.generate(72, (i) => i + 129 == 129 ? 1 : i + 129);

  final height2 = List<int>.generate(72, (i) => i + 129 == 129 ? 2000 : i + 129);

  int index1 = 0;
  int index2 = 0;
  int index3 = 0;
  int index4 = 0;

  bool checkOpen1 = false;
  bool checkOpen2 = false;
  bool checkOpen3 = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          checkOpen1 = !checkOpen1;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.width * 0.1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '学年',
                                style: TextStyle(
                                  fontSize: 17,
                                ),
                              ),
                              Flexible(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        items[index1],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: items[index1] == 'こだわらない'
                                              ? Colors.grey
                                              : Color(0xFFed1b24)
                                                  .withOpacity(0.77),
                                          fontSize: 17,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    checkOpen1
                        ? SizedBox(
                            height: 200,
                            child: Center(
                              child: CupertinoPicker(
                                itemExtent: 45,
                                children: items
                                    .map((item) => Center(
                                            child: Text(
                                          item,
                                          style: const TextStyle(fontSize: 25),
                                        )))
                                    .toList(),
                                onSelectedItemChanged: (index) {
                                  setState(() {
                                    this.index1 = index;
                                  });
                                },
                              ),
                            ),
                          )
                        : Container(),
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          checkOpen2 = !checkOpen2;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.width * 0.1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '学部',
                                style: TextStyle(
                                  fontSize: 17,
                                ),
                              ),
                              Flexible(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        major[index2],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: major[index2] == 'こだわらない'
                                              ? Colors.grey
                                              : Color(0xFFed1b24)
                                                  .withOpacity(0.77),
                                          fontSize: 17,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    checkOpen2
                        ? SizedBox(
                            height: 200,
                            child: Center(
                              child: CupertinoPicker(
                                itemExtent: 45,
                                children: major
                                    .map((item) => Center(
                                            child: Text(
                                          item,
                                          style: const TextStyle(fontSize: 25),
                                        )))
                                    .toList(),
                                onSelectedItemChanged: (index) {
                                  setState(() {
                                    this.index2 = index;
                                  });
                                },
                              ),
                            ),
                          )
                        : Container(),
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          checkOpen3 = !checkOpen3;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.width * 0.1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '身長',
                                style: TextStyle(
                                  fontSize: 17,
                                ),
                              ),
                              Flexible(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      height1[index3] == 1
                                          ? 'こだわらない'
                                          : height1[index3].toString() + 'cm',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: height1[index3] == 1
                                            ? Colors.grey
                                            : Color(0xFFed1b24)
                                                .withOpacity(0.77),
                                        fontSize: 17,
                                      ),
                                    ),
                                    Text(
                                      '−',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color(0xFFed1b24).withOpacity(0.77),
                                      ),
                                    ),
                                    Text(
                                      height2[index4] == 2000
                                          ? 'こだわらない'
                                          : height2[index4].toString() + 'cm',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: height2[index4] == 2000
                                            ? Colors.grey
                                            : Color(0xFFed1b24)
                                                .withOpacity(0.77),
                                        fontSize: 17,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    checkOpen3
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: 200,
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Center(
                                  child: CupertinoPicker(
                                    itemExtent: 40,
                                    children: height1
                                        .map((item) => Center(
                                                child: Text(
                                              item == 1
                                                  ? 'こだわらない'
                                                  : item.toString() + 'cm',
                                              style:
                                                  const TextStyle(fontSize: 25),
                                            )))
                                        .toList(),
                                    onSelectedItemChanged: (index) {
                                      setState(() {
                                        this.index3 = index;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                height: 200,
                                child: Center(
                                  child: CupertinoPicker(
                                    itemExtent: 45,
                                    children: height2
                                        .map((item) => Center(
                                                child: Text(
                                              item == 2000
                                                  ? 'こだわらない'
                                                  : item.toString() + 'cm',
                                              style:
                                                  const TextStyle(fontSize: 25),
                                            )))
                                        .toList(),
                                    onSelectedItemChanged: (index) {
                                      setState(() {
                                        this.index4 = index;
                                      });
                                    },
                                  ),
                                ),
                              )
                            ],
                          )
                        : Container(),
                  ]),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
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
                color: Colors.black,
              ),
            ),
            Text('検索条件', style: TextStyle(color: Colors.black)),
            Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        padding: EdgeInsets.only(bottom: 25, right: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              backgroundColor: Color(0xFFed1b24).withOpacity(0.77),
              onPressed: () async {
                Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (_, __, ___) =>
                                      MainPage(0, uid, items[index1],
                    major[index2], height1[index3], height2[index4]),
                                  transitionDuration: Duration(seconds: 0),
                                ));
              },
              child: const Icon(
                Icons.search,
                size: 40,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text('検索する'),
          ],
        ),
      ),
    );
  }
}

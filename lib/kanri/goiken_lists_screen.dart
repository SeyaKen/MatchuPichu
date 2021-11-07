import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:machupichu/kanri/goriyou_shousai.dart';
import 'package:machupichu/kanri/kanri_model.dart';

class GoikenListsScreen extends StatefulWidget {
  const GoikenListsScreen({Key? key}) : super(key: key);

  @override
  _GoikenListsScreenState createState() => _GoikenListsScreenState();
}

class _GoikenListsScreenState extends State<GoikenListsScreen> {
  Stream<QuerySnapshot<Object?>>? GoikenListsStream;

  getHomeLists() async {
    GoikenListsStream = await KanriModel().fetchGoikens();
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
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xFFed1b24).withOpacity(0.77),
          elevation: 0,
          toolbarHeight: 60,
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
                ),
              ),
              Text('ご意見リスト'),
              Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 30,
                color: Colors.transparent,
              ),
            ],
          )),
      resizeToAvoidBottomInset: false,
      body: StreamBuilder<QuerySnapshot>(
          stream: GoikenListsStream,
          builder: (context, snapshot) {
            print('home_list_pageのsnapshotのエラー');
            print(snapshot.hasData);
            print(snapshot.error);
            return snapshot.hasData
                ? GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    children: List.generate(snapshot.data!.docs.length, (i) {
                      DocumentSnapshot ds = snapshot.data!.docs[i];
                      return Builder(builder: (context) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (_, __, ___) =>
                                      GoriyouShousai(ds['goiken']),
                                  transitionDuration: Duration(seconds: 0),
                                ));
                          },
                          child: Container(
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color:
                                        Color(0xFFed1b24).withOpacity(0.77))),
                            child: Stack(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(5),
                                  child: Text(
                                    ds['goiken'],
                                  ),
                                ),
                                Align(
                                    alignment: Alignment.bottomCenter,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Color(0xFFed1b24)),
                                      onPressed: () async {
                                        await FirebaseFirestore.instance
                                            .collection('goiken')
                                            .doc(ds.id)
                                            .delete();
                                      },
                                      child: Text('削除'),
                                    ))
                              ],
                            ),
                          ),
                        );
                      });
                    }),
                  )
                : Center(child: CircularProgressIndicator());
          }),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:machupichu/kanri/kanri_model.dart';

class KanriScreen extends StatefulWidget {
  const KanriScreen({Key? key}) : super(key: key);

  @override
  _KanriScreenState createState() => _KanriScreenState();
}

class _KanriScreenState extends State<KanriScreen> {
  Stream<QuerySnapshot<Object?>>? KanriListsStream;

  getHomeLists() async {
    KanriListsStream = await KanriModel().fetchImages();
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
              Text('管理画面'),
              Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 30,
                color: Colors.transparent,
              ),
            ],
          )),
      resizeToAvoidBottomInset: false,
      body: StreamBuilder<QuerySnapshot>(
          stream: KanriListsStream,
          builder: (context, snapshot) {
            print('home_list_pageのsnapshotのエラー');
            print(snapshot.error);
            return snapshot.hasData
                ? GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 1,
                    children: List.generate(snapshot.data!.docs.length, (i) {
                      DocumentSnapshot ds = snapshot.data!.docs[i];
                      return Center(
                        child: Container(
                          child: Builder(builder: (context) {
                            return Column(
                              children: [
                                SizedBox(height: 30),
                                ds['imageURL'].isNotEmpty
                                    ? Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.85,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.85,
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
                                                0.85,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.85,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            SizedBox(
                                              width: 100,
                                              height: 50,
                                              child: ElevatedButton(
                                                onPressed: () async {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('user')
                                                      .doc(ds.id)
                                                      .update({
                                                    'kakuninbool': true
                                                  });
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('user')
                                                      .doc(ds.id)
                                                      .update({'kakunin': '3'});
                                                  await FirebaseStorage.instance
                                                      .refFromURL(
                                                          ds['imageURL'])
                                                      .delete();
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('mibunshou')
                                                      .doc(ds.id)
                                                      .delete();
                                                },
                                                child: Text('否認'),
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.red),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              ds['birthday'],
                                              style: TextStyle(
                                                color: Color(0xFFed1b24)
                                                    .withOpacity(0.77),
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 100,
                                              height: 30,
                                              child: ElevatedButton(
                                                  onPressed: () async {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('user')
                                                        .doc(ds.id)
                                                        .update({
                                                      'kakuninbool': true
                                                    });
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('user')
                                                        .doc(ds.id)
                                                        .update(
                                                            {'kakunin': '2'});
                                                    await FirebaseStorage
                                                        .instance
                                                        .refFromURL(
                                                            ds['imageURL'])
                                                        .delete();
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('mibunshou')
                                                        .doc(ds.id)
                                                        .delete();
                                                  },
                                                  child: Text('承認')),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      );
                    }),
                  )
                : Center(child: CircularProgressIndicator());
          }),
    );
  }
}

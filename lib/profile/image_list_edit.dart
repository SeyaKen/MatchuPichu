import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
          body: Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: StreamBuilder<QuerySnapshot>(
                    stream: profileListsStream,
                    builder: (context, snapshot) {
                      if (snapshot.data != null) {
                        this.ds = snapshot.data!.docs[0];
                        print(snapshot.error);
                      }
                      return snapshot.hasData
                          ? GridView.count(
                              crossAxisCount: 2,
                              childAspectRatio: 1,
                              children:
                                  List.generate(ds!['imageURL'].length, (i) {
                                int check = i % 2;
                                try {
                                  return Center(
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          left: check == 0 ? 5 : 0,
                                          right: check == 1 ? 5 : 0),
                                      child: InkWell(
                                        onTap: () {},
                                        child: Column(
                                          children: [
                                            ds!['imageURL'].isNotEmpty
                                                ? Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.43,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.43,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      child: Image.network(
                                                        ds!['imageURL'][i],
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  )
                                                : Stack(
                                                    children: [
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.43,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.43,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    ],
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
                          : Center(child: CircularProgressIndicator());
                    }),
              ),
              Positioned(
                bottom: 50,
                child: ElevatedButton(
                    onPressed: () async {
                      try{
                        await editService(uid).updateImage();
                      }catch(e){
                        print(e.toString());
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '写真を編集する',
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
          )),
    );
  }
}

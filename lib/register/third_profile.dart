import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:machupichu/register/forth_profile.dart';
import 'package:machupichu/services/database.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class ThirdProfile extends StatelessWidget {
  final picker = ImagePicker();

  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DatabaseService>(
      create: (_) => DatabaseService(uid),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.white,
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
          child: Center(
            child: SafeArea(
              child:
                  Consumer<DatabaseService>(builder: (context, model, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          '写真を設定しましょう！',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              color: Colors.black,
                              decoration: TextDecoration.none),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          '写真を設定することでマッチング率が',
                          style: TextStyle(
                              color: Colors.black,
                              decoration: TextDecoration.none),
                        ),
                        Text(
                          '大幅にアップします！',
                          style: TextStyle(
                              color: Colors.black,
                              decoration: TextDecoration.none),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100.0),
                      child: SizedBox(
                        height: 200,
                        width: 200,
                        child: InkWell(
                          onTap: () async {
                            await model.showImagePicker();
                          },
                          child: model.imageFile != null
                              ? Image.file(
                                  model.imageFile!,
                                  fit: BoxFit.cover,
                                )
                              : Container(color: Colors.grey),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 300.0,
                      child: ElevatedButton(
                          onPressed: () async {
                            await model.showImagePicker();
                          },
                          child: Text('写真をアップロードする'),
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFFed1b24).withOpacity(0.77),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10000.0),
                            ),
                          )),
                    )
                  ],
                );
              }),
            ),
          ),
        ),
        floatingActionButton:
            Consumer<DatabaseService>(builder: (context, model, child) {
          return InkWell(
            onTap: () async {
              if (model.imageFile == null) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return CupertinoAlertDialog(actions: [
                        CupertinoDialogAction(
                          isDefaultAction: true,
                          child: const Text("いいえ"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        CupertinoDialogAction(
                          textStyle: TextStyle(color: Colors.red),
                          isDefaultAction: true,
                          child: Text("はい"),
                          onPressed: () async {
                            await model.addImage();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ForthProfile(),
                                ));
                          },
                        )
                      ], title: Text('画像を後で設定しますか？'));
                    });
              } else {
                await model.addImage();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ForthProfile(),
                    ));
              }
            },
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '次のページへ行く',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Color(0xFFed1b24).withOpacity(0.77),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 30,
                    color: Color(0xFFed1b24).withOpacity(0.77),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

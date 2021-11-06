import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:machupichu/profile/sousin.dart';
import 'package:machupichu/services/database.dart';
import 'package:provider/provider.dart';

class Mibunnshoumei extends StatefulWidget {
  @override
  _MibunnshoumeiState createState() => _MibunnshoumeiState();
}

class _MibunnshoumeiState extends State<Mibunnshoumei> {
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
                Text(
                  '本人・年齢確認',
                  style: TextStyle(color: Colors.black),
                ),
                Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 30,
                  color: Colors.transparent,
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
                    SizedBox(height: 40),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.25,
                          width: MediaQuery.of(context).size.width * 0.85,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(11),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            '提出する学生証の写真を撮影しましょう。',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.white,
                                decoration: TextDecoration.none),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.85,
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(text: '※生年月日がはっきりと写っていない場合、もう一度提出し直していただく場合がございます。生年月日がはっきり写った写真を提出していただけると助かります。', style: TextStyle(color: Colors.black)),
                              TextSpan(text: '生年月日がはっきり写った写真', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                              TextSpan(text: 'を提出していただけると助かります。', style: TextStyle(color: Colors.black)),
                            ]
                          )
                        )
                    ),
                          
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.85,
                        child: Text(
                            '※個人情報保護のため、通信の暗号化を実施。本人・年齢確認後、すみやかに画像を処理します。')),
                    SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: 45,
                      child: ElevatedButton(
                          onPressed: () async {
                            await model.showCameraPicker(context);
                          },
                          child: Text('写真を撮る'),
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFFed1b24).withOpacity(0.77),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10000.0),
                            ),
                          )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: 45,
                      child: ElevatedButton(
                          onPressed: () async {
                            await model.showImagePicker();
                            model.imageFile != null
                                ? Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (_, __, ___) =>
                                          Sousin(uid, model.imageFile!),
                                      transitionDuration: Duration(seconds: 0),
                                    ))
                                : null;
                          },
                          child: Text('ライブラリから選ぶ'),
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
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:machupichu/main_page.dart';
import 'package:machupichu/services/database.dart';
import 'package:machupichu/services/sharedpref_helper.dart';

class SeventhProfile extends StatefulWidget {
  @override
  _SeventhProfileState createState() => _SeventhProfileState();
}

class _SeventhProfileState extends State<SeventhProfile> {
  String hitokoto = '';
  final _formKey = GlobalKey<FormState>();

  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final FocusScopeNode currentScope = FocusScope.of(context);
        if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 100,
              ),
              Text(
                'ひとことを設定しましょう！',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Form(
                key: _formKey,
                child: TextFormField(
                  onChanged: (val) {
                    setState(() => hitokoto = val);
                  },
                ),
              ),
            ],
          ),
        )),
        floatingActionButton: InkWell(
            onTap: () async {
              await DatabaseService(uid).updateUserHitokoto(hitokoto, uid);
              await DatabaseService(uid).allUpload();
              SharedPreferenceHelper().saveUserHitokoto(hitokoto);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainPage(0, 'a', 'a', 'a', 0, 0),
                  ));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '次のページへ行く',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Color(0xFFed1b24).withOpacity(0.77)),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 30,
                    color: Color(0xFFed1b24).withOpacity(0.77),
                  ),
                ],
              ),
            ),
          ),
      ),
    );
  }
}

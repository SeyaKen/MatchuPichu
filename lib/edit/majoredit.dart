import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:machupichu/services/editDatabase.dart';

class MajorEdit extends StatefulWidget {
  String _hasBeenPressed;
  MajorEdit(this._hasBeenPressed);
  @override
  _MajorEditState createState() => _MajorEditState(_hasBeenPressed);
}

class _MajorEditState extends State<MajorEdit> {
  String _hasBeenPressed;
  _MajorEditState(this._hasBeenPressed);
  final items = [
    '法学部',
    '経済学部',
    '商学部',
    '文学部',
    '総合政策学部',
    '国際経営学部',
    '国際情報学部',
    '理工学部',
  ];
  String uid = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
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
              Text(
                '学年',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
              ),
            ],
          )),
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: SafeArea(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                              child: Text(
                                items[index],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                  color: _hasBeenPressed == items[index]
                                      ? Colors.black
                                      : Colors.grey,
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  _hasBeenPressed = items[index];
                                });
                              }),
                        ],
                      ),
                    );
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 100,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          await editService(uid)
                              .updateUserMajor(_hasBeenPressed);
                          Navigator.pop(context);
                        },
                        child: Text('変更する'),
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xFFed1b24).withOpacity(0.77),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10000.0),
                            )),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

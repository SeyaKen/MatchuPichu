import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:machupichu/services/editDatabase.dart';

class GradeEdit extends StatefulWidget {
  String _hasBeenPressed;
  GradeEdit(this._hasBeenPressed);
  @override
  _GradeEditState createState() => _GradeEditState(_hasBeenPressed);
}

class _GradeEditState extends State<GradeEdit> {
  String _hasBeenPressed;
  _GradeEditState(this._hasBeenPressed);
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
        padding: const EdgeInsets.symmetric(horizontal: 50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50,
                ),
                InkWell(
                  child: Text(
                    '1年',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color:
                          _hasBeenPressed == '1年' ? Colors.black : Colors.grey,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _hasBeenPressed = '1年';
                    });
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  child: Text(
                    '2年',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color:
                          _hasBeenPressed == '2年' ? Colors.black : Colors.grey,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _hasBeenPressed = '2年';
                    });
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  child: Text(
                    '3年',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color:
                          _hasBeenPressed == '3年' ? Colors.black : Colors.grey,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _hasBeenPressed = '3年';
                    });
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  child: Text(
                    '4年',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color:
                          _hasBeenPressed == '4年' ? Colors.black : Colors.grey,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _hasBeenPressed = '4年';
                    });
                  },
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 100,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      await editService(uid).updateUserGrade(_hasBeenPressed);
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
    );
  }
}

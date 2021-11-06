import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:machupichu/services/editDatabase.dart';

class HeightEdit extends StatefulWidget {
  int _hasBeenPressed;
  HeightEdit(this._hasBeenPressed);
  @override
  _HeightEditState createState() => _HeightEditState(_hasBeenPressed);
}

class _HeightEditState extends State<HeightEdit> {
  final items = List<int>.generate(71, (i) => i + 130);
  int _hasBeenPressed;
  _HeightEditState(this._hasBeenPressed);
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
                '身長',
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
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: ListView.builder(
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
                                    items[index].toString() + 'cm',
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
                  ),
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
                              .updateUserHeight(_hasBeenPressed);
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

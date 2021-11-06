import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:machupichu/register/fifth_profile.dart';
import 'package:machupichu/services/database.dart';

class ForthProfile extends StatefulWidget {
  @override
  _ForthProfileState createState() => _ForthProfileState();
}

class _ForthProfileState extends State<ForthProfile> {
  final items = List<int>.generate(71, (i) => i + 130);
  int _hasBeenPressed = 130;

  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        body: Container(
          margin: const EdgeInsets.all(30.0),
          child: SafeArea(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '身長を教えてください',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.black,
                        decoration: TextDecoration.none),
                  ),
                  SizedBox(
                    height: 50,
                  ),
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
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: InkWell(
            onTap: () async {
              await DatabaseService(uid).updateUserHeight(_hasBeenPressed);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FifthProfile(),
                  ));
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 15.0, left: 15.0),
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
          ),);
  }
}

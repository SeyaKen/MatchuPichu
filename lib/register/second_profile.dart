import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:machupichu/register/third_profile.dart';
import 'package:machupichu/services/database.dart';

class SecondProfile extends StatefulWidget {
  @override
  _SecondProfileState createState() => _SecondProfileState();
}

class _SecondProfileState extends State<SecondProfile> {
  String _hasBeenPressed = '1年';

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
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
              ),
              Text(
                '学年を教えてください',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.black,
                    decoration: TextDecoration.none),
              ),
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: InkWell(
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
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: InkWell(
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
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: InkWell(
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
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: InkWell(
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
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: InkWell(
        onTap: () async {
          await DatabaseService(uid).updateUserGrade(_hasBeenPressed);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ThirdProfile(),
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
    );
  }
}

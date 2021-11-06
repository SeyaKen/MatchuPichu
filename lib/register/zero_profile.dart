import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:machupichu/register/first_profile.dart';
import 'package:machupichu/services/database.dart';

class ZeroProfile extends StatefulWidget {
  @override
  _ZeroProfileState createState() => _ZeroProfileState();
}

class _ZeroProfileState extends State<ZeroProfile> {
  String _hasBeenPressed = 'men';

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
        child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 50,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '性別を教えてください',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                Text(
                  '※あとで変えられません',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: InkWell(
                child: Text(
                  '男性',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color:
                        _hasBeenPressed == 'men' ? Colors.black : Colors.grey,
                  ),
                ),
                onTap: () {
                  setState(() {
                    _hasBeenPressed = 'men';
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
                  '女性',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color:
                        _hasBeenPressed == 'women' ? Colors.black : Colors.grey,
                  ),
                ),
                onTap: () {
                  setState(() {
                    _hasBeenPressed = 'women';
                  });
                },
              ),
            ),
          ],
        ),
      )),
      floatingActionButton: InkWell(
        onTap: () async {
          try {
            print(uid);
            await DatabaseService(uid).updateUserSex(_hasBeenPressed);
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FirstProfile(),
                ));
          } catch (e) {
            print(e.toString());
          }
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

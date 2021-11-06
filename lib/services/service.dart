import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:machupichu/mailSignin/mailAuthenticate.dart';
import 'package:machupichu/main_page.dart';
import 'package:machupichu/services/database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'sharedpref_helper.dart';

class Service {
  final auth = FirebaseAuth.instance;

  //get current user
  getCurrentUser() async {
    return auth.currentUser;
  }

  void loginUser(context, email, password) async {
    try {
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) => {
                Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) =>
                          MainPage(0, 'a', 'a', 'a', 0, 0),
                      transitionDuration: Duration(seconds: 0),
                    ))
              });
    } catch (e) {
      errorBox(context, e);
    }
  }

  void signOut(context) async {
    try {
      await auth.signOut().then((value) => {
            Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => mailAuthenticate(),
                  transitionDuration: Duration(seconds: 0),
                ))
          });
      // ここでメールアドレスのキーを外す
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.remove('email');
    } catch (e) {
      errorBox(context, e);
    }
  }

  void errorBox(context, e) {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('エラー'),
          content: Text(e.toString()),
        );
      },
    );
  }

  Future<User?> signInWithGoogle(BuildContext context) async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    UserCredential result =
        await _firebaseAuth.signInWithCredential(credential);
    User? userDetails = result.user;

    if (result != null) {
      SharedPreferenceHelper().saveUserEmail(userDetails!.email);
      SharedPreferenceHelper().saveUserId(userDetails.uid);
      SharedPreferenceHelper()
          .saveUserName(userDetails.email!.replaceAll("@gmail.com", ""));
      SharedPreferenceHelper().saveDisplayName(userDetails.displayName);
      SharedPreferenceHelper().saveUserProfileUrl(userDetails.photoURL);

      Map<String, dynamic> userInfoMap = {
        'email': userDetails.email,
        "username": userDetails.email!.replaceAll("@gmail.com", ""),
        'name': userDetails.displayName,
        'imageUrl': userDetails.photoURL,
      };
      String uid = await auth.currentUser!.uid;
      DatabaseService(uid)
          .addUserInfoToDB(userDetails.uid, userInfoMap)
          .then((value) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => MainPage(0, 'a', 'a', 'a', 0, 0)));
      });
    }
  }
}

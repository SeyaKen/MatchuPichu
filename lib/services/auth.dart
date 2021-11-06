import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:machupichu/mailSignin/mailAuthenticate.dart';
import 'package:machupichu/main_page.dart';
import 'package:machupichu/register/kakunin.dart';
import 'package:machupichu/services/database.dart';
import 'package:machupichu/services/sharedpref_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;

  //get current user
  getCurrentUser() async {
    return auth.currentUser;
  }

  Future fetchImage() async {
    String uid = await auth.currentUser!.uid;
    return FirebaseFirestore.instance.collection('user').doc(uid).get();
  }

  Future signInWithGoogle(BuildContext context) async {
    try {
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
      try {
        final doc = await fetchImage();
        // ここでログインしているかどうか確認するから消さないで！！
        print(doc['hitokoto']);
        SharedPreferenceHelper().saveUserHitokoto(doc['hitokoto']);
        Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => MainPage(0, 'a', 'a', 'a', 0, 0),
              transitionDuration: Duration(seconds: 0),
            ));
      } catch (e) {
        Map<String, dynamic> userInfoMap = {
          'email': userDetails!.email,
        };
        String uid = await auth.currentUser!.uid;
        DatabaseService(uid).addUserInfoToDB(userDetails.uid, userInfoMap);
        Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => Kakunin(),
              transitionDuration: Duration(seconds: 0),
            ));
      }
    } catch (e) {
      print('エラーが発生しました');
      print(e.toString());
      Navigator.pop(context);
    }
  }

  Future signOut(context) async {
    // ここでキーを外す
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    auth.signOut().then((value) => {
          Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => mailAuthenticate(),
                transitionDuration: Duration(seconds: 0),
              ))
        });
  }
}

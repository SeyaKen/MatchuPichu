import 'package:fcm_config/fcm_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:machupichu/domain/user.dart';
import 'package:machupichu/main_page.dart';
import 'package:machupichu/register/kakunin.dart';
import 'package:machupichu/services/auth.dart';
import 'package:machupichu/services/database.dart';
import 'package:machupichu/services/editDatabase.dart';
import 'package:machupichu/services/sharedpref_helper.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  // Firebaseの「User」に基づいてユーザーオブジェクトを作る
  Userr? _userFromFirebaseUser(User? user) {
    return user != null ? Userr(user.uid) : null;
  }

  Stream<Userr?> get user {
    return auth
        .authStateChanges()
        .map((User? user) => _userFromFirebaseUser(user));
  }

  // メールアドレスとパスワードでログイン
  Future signInWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      final doc = await AuthMethods().fetchImage();
      try {
        SharedPreferenceHelper().saveUserHitokoto(doc['hitokoto']);
        String? token = await FCMConfig.messaging.getToken();
        String uid = FirebaseAuth.instance.currentUser!.uid;
        editService(uid).updateUserToken(token!);
        Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => MainPage(0, 'a', 'a', 'a', 0, 0),
              transitionDuration: Duration(seconds: 0),
            ));
      } catch (e) {
        print(e.toString());
        String? token = await FCMConfig.messaging.getToken();
        String uid = FirebaseAuth.instance.currentUser!.uid;
        editService(uid).updateUserToken(token!);
        Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => Kakunin(),
              transitionDuration: Duration(seconds: 0),
            ));
      }
    } catch (e) {
      print(e.toString());
      if (e.toString() ==
          '[firebase_auth/wrong-password] The password is invalid or the user does not have a password.') {
        errorBox(context, 'パスワードが間違っています。');
      } else if (e.toString() ==
          '[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.') {
        errorBox(context, '一致するユーザーが見つかりません。新規登録画面から登録してください。');
      }
    }
  }

  // メールアドレスとパスワードで登録
  Future registerWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
      UserCredential result = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? userDetails = result.user;
      Map<String, dynamic> userInfoMap = {
        'email': userDetails!.email,
      };
      String uid = await auth.currentUser!.uid;
      DatabaseService(uid).addUserInfoToDB(userDetails.uid, userInfoMap);
      String? token = await FCMConfig.messaging.getToken();
      editService(uid).updateUserToken(token!);
      Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => Kakunin(),
            transitionDuration: Duration(seconds: 0),
          ));
    } catch (e) {
      print('エラーが発生しました');
      print(e.toString());
      errorBox(
          context,
          e.toString() ==
                  '[firebase_auth/email-already-in-use] The email address is already in use by another account.'
              ? '既に登録済みです。ログイン画面からログインしてください。'
              : 'メールアドレスまたはパスワードが違います。');
    }
  }

  void errorBox(context, e) {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text("閉じる"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
          title: Text('エラー'),
          content: Text(e.toString()),
        );
      },
    );
  }
}

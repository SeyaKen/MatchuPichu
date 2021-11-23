import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fcm_config/fcm_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:machupichu/domain/list.dart';
import 'package:machupichu/settings/sousin.dart';

class DatabaseService extends ChangeNotifier {
  final String uid;
  DatabaseService(this.uid);
  File? imageFile;
  Imag? imgs;
  String? sex;

  final CollectionReference brewCollection =
      FirebaseFirestore.instance.collection('user');

  final CollectionReference menList =
      FirebaseFirestore.instance.collection('men');

  final CollectionReference womenList =
      FirebaseFirestore.instance.collection('women');

  Future<Stream<QuerySnapshot>> fetchImage() async {
    return FirebaseFirestore.instance
        .collection('user')
        .where('uid', isEqualTo: uid)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> fetchIine(String chatroomId) async {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .where('chatRoomId', isEqualTo: chatroomId)
        .snapshots();
  }

  Future updateIine(String chatroomId) async {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatroomId)
        .update({'${uid}iine': 1});
  }

  Future updateUserSex(String sex) async {
    await brewCollection.doc(uid).update({
      'sex': sex,
    });
    this.sex = sex;
    final token = await FCMConfig.messaging.getToken();
    await brewCollection.doc(uid).collection('token').doc('token').update({
      'token': token,
    });
  }

  Future updateUserName(String name) async {
    await brewCollection.doc(uid).update({
      'name': name,
    });
  }

  Future updateUserGrade(String grade) async {
    await brewCollection.doc(uid).update({
      'grade': grade,
    });
  }

  Future updateUserHeight(int height) async {
    await brewCollection.doc(uid).update({
      'height': height,
    });
  }

  Future updateUserMajor(String major) async {
    await brewCollection.doc(uid).update({
      'major': major,
    });
  }

  Future updateUserEx(String ex) async {
    await brewCollection.doc(uid).update({
      'ex': ex,
    });
  }

  Future updateUserHitokoto(String hitokoto, uid) async {
    await brewCollection.doc(uid).update({
      'hitokoto': hitokoto,
      'uid': uid,
      'notifications': 0,
      'osirase': true,
      'kakunin': '0',
      'kakuninbool': false,
    });
  }

  // 画像を処理する関数

  Future<String> uploadMibunshou(File mibunFile) async {
    final storage = FirebaseStorage.instance;
    final ref = storage.ref().child('mibunshoumei').child(uid);

    final snapshot = await ref.putFile(
      mibunFile,
    );
    final urlDownload = await snapshot.ref.getDownloadURL();

    return urlDownload;
  }

  Future addTuuhou(String tuuhou, String aitenoUid, myUid) async {
    // firebaseに追加
    await FirebaseFirestore.instance.collection('tuuhou').doc().set({
      'tuuhou': tuuhou,
      'aitenoUid': aitenoUid,
      'myUid': myUid,
    });
  }

  Future addGoiken(String goiken) async {
    // firebaseに追加
    await FirebaseFirestore.instance.collection('goiken').doc().set({
      'goiken': goiken,
    });
  }

  Future addMibunshou(
      File mibunFile, String birthday, DateTime sousintime) async {
    final imageURL = await uploadMibunshou(mibunFile);

    // firebaseに追加
    await FirebaseFirestore.instance.collection('mibunshou').doc(uid).set({
      'imageURL': imageURL,
      'birthday': birthday,
      'sousintime': sousintime,
    });
    fetchImage();
  }

  Future showCameraPicker(context) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      imageFile = File(pickedFile!.path);
      notifyListeners();
      Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => Sousin(uid, this.imageFile!),
            transitionDuration: Duration(seconds: 0),
          ));
    } catch (e) {
      print(e);
      imageFile = null;
      notifyListeners();
    }
  }

  Future updateImage() async {
    await showImagePicker();
    await addImage();
    notifyListeners();
  }

  Future showImagePicker() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      imageFile = File(pickedFile!.path);
      notifyListeners();
      return imageFile;
    } catch (e) {
      print(e);
      imageFile = null;
      notifyListeners();
    }
  }

  Future addImage() async {
    final imageURL = await uploadFile();

    // firebaseに追加
    await brewCollection.doc(uid).update({
      'imageURL': imageURL,
    });
    fetchImage();
  }

  // ファイルをアップロードする関数
  Future<String> uploadFile() async {
    if (imageFile == null) {
      return 'https://firebasestorage.googleapis.com/v0/b/machupichu-a5cd2.appspot.com/o/public%2FScreen%20Shot%202021-11-13%20at%2014.52.24.png?alt=media&token=d9099648-9870-4005-b3aa-387a8684dc56';
    } else {
      final storage = FirebaseStorage.instance;
      final ref = storage.ref().child('images').child(uid);

      final snapshot = await ref.putFile(
        imageFile!,
      );

      final urlDownload = await snapshot.ref.getDownloadURL();

      return urlDownload;
    }
  }

  // チャットで画像をアップロードする処理
  Future chatUpdateImage(String randomAlphabet) async {
    await showImagePicker();
    String chaturl = await chatUploadFile(randomAlphabet);
    return chaturl;
  }

  Future chatUpdateCamera(String randomAlphabet, context) async {
    await showCameraPicker(context);
    String chaturl = await chatUploadFile(randomAlphabet);
    return chaturl;
  }

  Future<String> chatUploadFile(String randomAlphabet) async {
    if (imageFile == null) {
      return '';
    }
    final storage = FirebaseStorage.instance;
    final ref = storage.ref().child('images').child(randomAlphabet);

    final snapshot = await ref.putFile(
      imageFile!,
    );

    final urlDownload = await snapshot.ref.getDownloadURL();

    return urlDownload;
  }
  // 画像を処理する関数

  // 退会ユーザー情報削除の関数
  Future deleteUser() async {
    final doc =
        await FirebaseFirestore.instance.collection('user').doc(uid).get();
    FirebaseFirestore.instance
        .collection("user")
        .doc(uid)
        .collection('token')
        .doc('token')
        .delete();
    if (doc['sex'] == 'men') {
      await menList.doc(uid).delete();
      await FirebaseFirestore.instance.collection('user').doc(uid).delete();
    } else {
      await womenList.doc(uid).delete();
      await FirebaseFirestore.instance.collection('user').doc(uid).delete();
    }
  }

  Future allUpload() async {
    final doc =
        await FirebaseFirestore.instance.collection('user').doc(uid).get();
    if (doc['sex'] == 'men') {
      return await menList.doc(uid).set({
        'sex': doc['sex'],
        'uid': uid,
        'ex': doc['ex'],
        'grade': doc['grade'],
        'height': doc['height'],
        'hitokoto': doc['hitokoto'],
        'imageURL': doc['imageURL'],
        'major': doc['major'],
        'name': doc['name'],
        'notifications': 0,
        'osirase': true,
      });
    } else {
      return await womenList.doc(uid).set({
        'sex': doc['sex'],
        'uid': uid,
        'ex': doc['ex'],
        'grade': doc['grade'],
        'height': doc['height'],
        'hitokoto': doc['hitokoto'],
        'imageURL': doc['imageURL'],
        'major': doc['major'],
        'name': doc['name'],
        'notifications': 0,
        'osirase': true,
      });
    }
  }

  Future uploadNotification(int? notifications) async {
    final doc =
        await FirebaseFirestore.instance.collection('user').doc(uid).get();

    await brewCollection.doc(uid).update({
      'notifications': notifications,
    });

    if (doc['sex'] == 'men') {
      return await menList.doc(uid).update({
        'notifications': notifications,
      });
    } else {
      return await womenList.doc(uid).update({
        'notifications': notifications,
      });
    }
  }

  Future addUserInfoToDB(String userId, Map<String, dynamic> userInfoMap) {
    return FirebaseFirestore.instance
        .collection('user')
        .doc(userId)
        .set(userInfoMap);
  }

  Future addMessage(String chatRoomId, String messageId,
      Map<String, dynamic> messageInfoMap) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .doc(messageId)
        .set(messageInfoMap);
  }

  updateLastMessageSend(
      String chatRoomId, Map<String, Object?> lastMessageInfoMap) {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .update(lastMessageInfoMap);
  }

  updateLastNyuusitu(String chatRoomId, String myUid) {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .update({'${myUid}nyuusitu': true});
  }

  minusNyuusitu(String chatRoomId, String myUid) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .update({'${myUid}nyuusitu': false});
  }

  createChatRoom(
      String chatRoomId, Map<String, dynamic> chatRoomInfoMap) async {
    final snapShot = await FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomId)
        .get();
    if (snapShot.exists) {
      // chatroom already exists
      return true;
    } else {
      // chatroom does not exists
      return FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(chatRoomId)
          .set(chatRoomInfoMap);
    }
  }

  blockChatRoom(String chatRoomId) async {
    // chatroom does not exists
    String block = chatRoomId.replaceAll(uid, '').replaceAll('_', '');
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomId)
        .update({
      "users": [block],
      "${uid}mute": true,
      "${uid}block": true,
    });
  }

  deleteChatRoom(String chatRoomId) async {
    // chatroom does not exists
    String block = chatRoomId.replaceAll(uid, '').replaceAll('_', '');
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomId)
        .update({
      "users": [block],
    });
  }

  kaijoChatRoom(String chatRoomId) async {
    // chatroom does not exists
    String block = chatRoomId.replaceAll(uid, '').replaceAll('_', '');
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomId)
        .update({
      "users": [block, uid],
      "${uid}block": false,
    });
  }

  muteChatRoom(String chatRoomId, bool mute) async {
    // chatroom does not exists
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomId)
        .update({
      "${uid}mute": mute,
    });
  }

  // Streamを作成
  Future<Stream<QuerySnapshot>> getChatRoomMessages(chatRoomId) async {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection('chats')
        .orderBy('ts', descending: true)
        .snapshots();
  }

  // chatroom一覧を表示するための関数
  Future<Stream<QuerySnapshot>> getChatRooms() async {
    String? myUserUid = await FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .orderBy("lastMessageSendTs", descending: true)
        .where("users", arrayContains: myUserUid)
        .snapshots();
  }

  // bottomNavigatorの通知の数を取得
  Future<Stream<QuerySnapshot>> getNotifications() async {
    String? myUserUid = await FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection("user")
        .where("uid", isEqualTo: myUserUid)
        .snapshots();
  }

  // お知らせの数を取得
  Future<Stream<QuerySnapshot>> getOsirase() async {
    return FirebaseFirestore.instance
        .collection('osirase')
        .orderBy('ts', descending: true)
        .snapshots();
  }

  Future<QuerySnapshot> getUserInfo(String myUserUid, uid) async {
    final doc = await FirebaseFirestore.instance
        .collection('user')
        .doc(myUserUid)
        .get();
    if (doc['sex'] == 'men') {
      return await FirebaseFirestore.instance
          .collection('women')
          .where('uid', isEqualTo: uid)
          .get();
    } else {
      return await FirebaseFirestore.instance
          .collection('men')
          .where('uid', isEqualTo: uid)
          .get();
    }
  }
}

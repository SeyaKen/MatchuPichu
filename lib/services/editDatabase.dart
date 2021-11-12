import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:machupichu/domain/list.dart';

class editService extends ChangeNotifier {
  final String uid;
  editService(this.uid);
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
    final doc =
        await FirebaseFirestore.instance.collection('user').doc(uid).get();

    if (doc['sex'] == 'men') {
      this.sex = 'men';
    } else {
      this.sex = 'women';
    }
    return FirebaseFirestore.instance
        .collection(sex!)
        .where('uid', isEqualTo: uid)
        .snapshots();
  }

  Future updateUserToken(String token) async {
    await brewCollection.doc(uid).collection('token').doc('token').set({
      'token': token,
    });
  }

  Future updateUserName(String name) async {
    final doc =
        await FirebaseFirestore.instance.collection('user').doc(uid).get();
    await brewCollection.doc(uid).update({
      'name': name,
    });
    if (doc['sex'] == 'men') {
      return await menList.doc(uid).update({
        'name': name,
      });
    } else {
      return await womenList.doc(uid).update({
        'name': name,
      });
    }
  }

  Future updateUserGrade(String grade) async {
    final doc =
        await FirebaseFirestore.instance.collection('user').doc(uid).get();
    await brewCollection.doc(uid).update({
      'grade': grade,
    });
    if (doc['sex'] == 'men') {
      return await menList.doc(uid).update({
        'grade': grade,
      });
    } else {
      return await womenList.doc(uid).update({
        'grade': grade,
      });
    }
  }

  Future updateUserHeight(int height) async {
    final doc =
        await FirebaseFirestore.instance.collection('user').doc(uid).get();
    await brewCollection.doc(uid).update({
      'height': height,
    });
    if (doc['sex'] == 'men') {
      return await menList.doc(uid).update({
        'height': height,
      });
    } else {
      return await womenList.doc(uid).update({
        'height': height,
      });
    }
  }

  Future updateUserMajor(String major) async {
    final doc =
        await FirebaseFirestore.instance.collection('user').doc(uid).get();
    await brewCollection.doc(uid).update({
      'major': major,
    });
    if (doc['sex'] == 'men') {
      return await menList.doc(uid).update({
        'major': major,
      });
    } else {
      return await womenList.doc(uid).update({
        'major': major,
      });
    }
  }

  Future updateUserEx(String ex) async {
    final doc =
        await FirebaseFirestore.instance.collection('user').doc(uid).get();
    await brewCollection.doc(uid).update({
      'ex': ex,
    });
    if (doc['sex'] == 'men') {
      return await menList.doc(uid).update({
        'ex': ex,
      });
    } else {
      return await womenList.doc(uid).update({
        'ex': ex,
      });
    }
  }

  Future updateUserHitokoto(String hitokoto) async {
    final doc =
        await FirebaseFirestore.instance.collection('user').doc(uid).get();
    await brewCollection.doc(uid).update({
      'hitokoto': hitokoto,
    });
    if (doc['sex'] == 'men') {
      return await menList.doc(uid).update({
        'hitokoto': hitokoto,
      });
    } else {
      return await womenList.doc(uid).update({
        'hitokoto': hitokoto,
      });
    }
  }

  // 画像を処理する関数

  Future updateImage() async {
    await showImagePicker();
    await addImage();
    notifyListeners();
  }

  Future showImagePicker() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    imageFile = File(pickedFile!.path);
    notifyListeners();
  }

  Future addImage() async {
    final imageURL = await uploadFile();

    // firebaseに追加
    final doc =
        await FirebaseFirestore.instance.collection('user').doc(uid).get();
    await brewCollection.doc(uid).update({
      'imageURL': imageURL,
    });
    if (doc['sex'] == 'men') {
      await menList.doc(uid).update({
        'imageURL': imageURL,
      });
    } else {
      await womenList.doc(uid).update({
        'imageURL': imageURL,
      });
    }
    CollectionReference ref =
        FirebaseFirestore.instance.collection("chatrooms");
    QuerySnapshot eventsQuery =
        await ref.where("users", arrayContains: uid).get();
    eventsQuery.docs.forEach((msgDoc) {
      msgDoc.reference.update({'${uid}': imageURL});
    });
    fetchImage();
  }

  // ファイルをアップロードする関数
  Future<String> uploadFile() async {
    if (imageFile == null) {
      return '';
    }
    final storage = FirebaseStorage.instance;
    final ref = storage.ref().child('images').child(uid);

    final snapshot = await ref.putFile(
      imageFile!,
    );

    final urlDownload = await snapshot.ref.getDownloadURL();

    return urlDownload;
  }
  // 画像を処理する関数
}

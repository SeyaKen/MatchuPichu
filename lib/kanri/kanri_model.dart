import 'package:cloud_firestore/cloud_firestore.dart';

class KanriModel {
  Future<Stream<QuerySnapshot>> fetchImages() async {
    return FirebaseFirestore.instance.collection('mibunshou').orderBy("sousintime").snapshots();
  }

  Future<Stream<QuerySnapshot>> fetchGoikens() async {
    return FirebaseFirestore.instance.collection('goiken').snapshots();
  }
}

  

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:machupichu/domain/list.dart';

class HomeListModel {
  List<Imag>? imgs;
  final String uid;
  HomeListModel(this.uid);
  String? sex;

  Future<Stream<QuerySnapshot>> fetchImages(int suuji) async {
    final doc =
        await FirebaseFirestore.instance.collection('user').doc(uid).get();

    if (doc['sex'] == 'men') {
      this.sex = 'women';
    } else {
      this.sex = 'men';
    }
    return FirebaseFirestore.instance.collection(this.sex!).limit(suuji).snapshots();
  }

  // 検索機能
  Future<Stream<QuerySnapshot>> getSearchInfo(String myUserUid, String grade,
      String major, int height1, int height2) async {
    final doc = await FirebaseFirestore.instance
        .collection('user')
        .doc(myUserUid)
        .get();
    if (doc['sex'] == 'men') {
      if (grade == 'こだわらない' && major == 'こだわらない') {
        return await FirebaseFirestore.instance
            .collection('women')
            .where("height", isGreaterThanOrEqualTo: height1)
            .where("height", isLessThanOrEqualTo: height2)
            .snapshots();
      } else if (grade == 'こだわらない' && major != 'こだわらない') {
        return await FirebaseFirestore.instance
            .collection('women')
            .where('major', isEqualTo: major)
            .where("height", isGreaterThanOrEqualTo: height1)
            .where("height", isLessThanOrEqualTo: height2)
            .snapshots();
      } else if (grade != 'こだわらない' && major == 'こだわらない') {
        return await FirebaseFirestore.instance
            .collection('women')
            .where('grade', isEqualTo: grade)
            .where("height", isGreaterThanOrEqualTo: height1)
            .where("height", isLessThanOrEqualTo: height2)
            .snapshots();
      } else {
        return await FirebaseFirestore.instance
            .collection('women')
            .where('grade', isEqualTo: grade == 'こだわらない' ? '年' : grade)
            .where('major', isEqualTo: major == 'こだわらない' ? '部' : major)
            .where("height", isGreaterThanOrEqualTo: height1)
            .where("height", isLessThanOrEqualTo: height2)
            .snapshots();
      }
    } else {
      if (grade == 'こだわらない' && major == 'こだわらない') {
        return await FirebaseFirestore.instance
            .collection('men')
            .where("height", isGreaterThanOrEqualTo: height1)
            .where("height", isLessThanOrEqualTo: height2)
            .snapshots();
      } else if (grade == 'こだわらない' && major != 'こだわらない') {
        return await FirebaseFirestore.instance
            .collection('men')
            .where('major', isEqualTo: major)
            .where("height", isGreaterThanOrEqualTo: height1)
            .where("height", isLessThanOrEqualTo: height2)
            .snapshots();
      } else if (grade != 'こだわらない' && major == 'こだわらない') {
        return await FirebaseFirestore.instance
            .collection('men')
            .where('grade', isEqualTo: grade)
            .where("height", isGreaterThanOrEqualTo: height1)
            .where("height", isLessThanOrEqualTo: height2)
            .snapshots();
      } else {
        return await FirebaseFirestore.instance
            .collection('men')
            .where('grade', isEqualTo: grade == 'こだわらない' ? '年' : grade)
            .where('major', isEqualTo: major == 'こだわらない' ? '部' : major)
            .where("height", isGreaterThanOrEqualTo: height1)
            .where("height", isLessThanOrEqualTo: height2)
            .snapshots();
      }
    }
  }
}

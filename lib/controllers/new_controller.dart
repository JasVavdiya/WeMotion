import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:wemotions/constants.dart';
import 'package:wemotions/models/news.dart';

class NewsController extends GetxController {
  Future<List<News>> fetchNewsArticles() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('news')
        .orderBy('timestamp', descending: true)
        .get();

    return querySnapshot.docs.map((doc) => News.fromDocument(doc)).toList();
  }

  likeNews(String id) async {
    DocumentSnapshot doc = await firestore.collection('news').doc(id).get();
    var uid = authController.user.uid;
    if ((doc.data()! as dynamic)['likes'].contains(uid)) {
      await firestore.collection('news').doc(id).update({
        'likes': FieldValue.arrayRemove([uid]),
      });
    } else {
      await firestore.collection('news').doc(id).update({
        'likes': FieldValue.arrayUnion([uid]),
      });
    }
  }
}

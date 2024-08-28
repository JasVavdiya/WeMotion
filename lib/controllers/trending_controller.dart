import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:wemotions/constants.dart';

class TrendingController extends GetxController {
  Future<List<Map<String, dynamic>>> fetchTrendingVideos() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('videos')
          .orderBy('likes', descending: true)
          .limit(10) // Limit to the top 10 trending videos
          .get();

      List<Map<String, dynamic>> trendingVideos = [];

      querySnapshot.docs.forEach((doc) {
        trendingVideos.add(doc.data() as Map<String, dynamic>);
      });

      return trendingVideos;
    } catch (e) {
      print("Error fetching trending videos: $e");
      return [];
    }
  }
}

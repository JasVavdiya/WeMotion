import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:wemotions/constants.dart';

class HomeController extends GetxController {
  Future<List<Map<String, dynamic>>> getHastiUsersWithMentionedVideos() async {
    List<Map<String, dynamic>> userProfilesWithVideos = [];

    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Step 1: Fetch profiles of users with is_hasti set to true
      QuerySnapshot usersSnapshot = await firestore
          .collection('users')
          .where('is_hasti', isEqualTo: true)
          .get();

      for (var userDoc in usersSnapshot.docs) {
        String uid = userDoc.id;
        Map<String, dynamic> userProfile = {
          'uid': uid,
          'email': userDoc['email'],
          'username': userDoc['username'],
          'name': userDoc['name'],
          'profilePhoto': userDoc['profilePhoto'],
          // Add other user fields if needed
        };

        // Step 2: Fetch videos where this user's UID is mentioned
        QuerySnapshot videosSnapshot = await firestore
            .collection('videos')
            .where('mentions', arrayContains: uid)
            .get();

        List<Map<String, dynamic>> mentionedVideos = videosSnapshot.docs.map((videoDoc) {
          return {
            'videoId': videoDoc.id,
            'videoData': videoDoc.data(),
          };
        }).toList();

        // Add the videos to the user profile
        userProfile['mentionedVideos'] = mentionedVideos;

        // Add the user profile with mentioned videos to the list
        userProfilesWithVideos.add(userProfile);
      }
    } catch (e) {
      print('Error fetching user profiles and videos: $e');
    }

    return userProfilesWithVideos;
  }
}

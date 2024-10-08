import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:wemotions/constants.dart';
import 'package:wemotions/models/comment.dart';

class CommentController extends GetxController {
  final Rx<List<Comment>> _comments = Rx<List<Comment>>([]);
  List<Comment> get comments => _comments.value;

  String _postId = "";
  Comment? parentComment; // Track the comment being replied to

  updatePostId(String id, String type) {
    _postId = id;
    getComment(type);
  }

  getComment(String type) async {
    _comments.bindStream(
      firestore
          .collection(type == 'videos' ? 'videos' : 'news')
          .doc(_postId)
          .collection('comments')
          .snapshots()
          .map(
            (QuerySnapshot query) {
          List<Comment> retValue = [];
          for (var element in query.docs) {
            retValue.add(Comment.fromSnap(element));
          }
          return retValue;
        },
      ),
    );
  }

  Future<String> _uploadAudioToStorage(String id, String audioPath) async {
    Reference ref = firebaseStorage.ref().child('audio').child(id);

    UploadTask uploadTask = ref.putFile(File(audioPath));
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  postComment(String audioPath, String type) async {
    try {
      if (audioPath.isNotEmpty) {
        DocumentSnapshot userDoc = await firestore
            .collection('users')
            .doc(authController.user.uid)
            .get();

        var allDocs = await firestore
            .collection(type == 'videos' ? 'videos' : 'news')
            .doc(_postId)
            .collection('comments')
            .get();
        int len = allDocs.docs.length;

        String audioUrl = await _uploadAudioToStorage(type == 'videos' ? 'Video_$len' : 'News_$len', audioPath);

        Comment comment = Comment(
          username: (userDoc.data()! as dynamic)['name'],
          audioUrl: audioUrl,
          uploadTimestamp: Timestamp.now(),
          likes: [],
          replies: <Comment>[], // Initialize empty list for replies
          profilePhoto: (userDoc.data()! as dynamic)['profilePhoto'],
          uid: authController.user.uid,
          id: 'comment_$len',
        );

        await firestore
            .collection(type == 'videos' ? 'videos' : 'news')
            .doc(_postId)
            .collection('comments')
            .doc('comment_$len')
            .set(
          comment.toJson(),
        );

        DocumentSnapshot doc =
        await firestore.collection(type == 'videos' ? 'videos' : 'news').doc(_postId).get();
        await firestore.collection(type == 'videos' ? 'videos' : 'news').doc(_postId).update({
          'commentCount': (doc.data()! as dynamic)['commentCount'] + 1,
        });

        // Reset parentComment after posting a comment
        parentComment = null;
      } else {
        print('Warning: Audio path not found!');
      }
    } catch (e) {
      print('Error While Commenting: ' + e.toString());
      Get.snackbar(
        'Error While Commenting',
        e.toString(),
      );
    }
  }


  void replyToComment(Comment parentComment, String audioPath) async {
    try {
      if (audioPath.isEmpty) {
        Get.snackbar('Warning','Audio path not found!');
        print('Warning: Audio path not found!');
        return;
      }

      // Ensure parentComment exists in Firestore
      DocumentReference parentDocRef = firestore
          .collection('videos')
          .doc(_postId)
          .collection('comments')
          .doc(parentComment.id);

      DocumentSnapshot parentDoc = await parentDocRef.get();

      if (!parentDoc.exists) {
        Get.snackbar('Parent comment does not exist.','Parent comment does not exist.');
        print('Parent comment does not exist.');
        // return;
      }

      DocumentSnapshot userDoc = await firestore
          .collection('users')
          .doc(authController.user.uid)
          .get();

      var allDocs = await firestore
          .collection('videos')
          .doc(_postId)
          .collection('comments')
          .get();
      int len = allDocs.docs.length;

      String audioUrl = await _uploadAudioToStorage("reply_$len", audioPath);

      Comment reply = Comment(
        username: (userDoc.data()! as dynamic)['name'],
        audioUrl: audioUrl,
        uploadTimestamp: Timestamp.now(),
        likes: [],
        replies: <Comment>[],
        profilePhoto: (userDoc.data()! as dynamic)['profilePhoto'],
        uid: authController.user.uid,
        id: 'reply$len',
      );



      // Update the parent comment with the new reply
      await firestore
          .collection('videos')
          .doc(_postId)
          .collection('comments')
          .doc(parentComment.id)
          .update({
        'replies': FieldValue.arrayUnion([reply.toJson()]),
      });

      Get.snackbar(
          'Audio posted successfully',
          "enjoy!"
      );
    } catch (e) {
      print('Error While Replying: ' + e.toString());
      Get.snackbar('Error While Replying', e.toString());
    }
  }

  likeComment(String id) async {
    var uid = authController.user.uid;
    DocumentSnapshot doc = await firestore
        .collection('videos')
        .doc(_postId)
        .collection('comments')
        .doc(id)
        .get();

    if ((doc.data()! as dynamic)['likes'].contains(uid)) {
      await firestore
          .collection('videos')
          .doc(_postId)
          .collection('comments')
          .doc(id)
          .update({
        'likes': FieldValue.arrayRemove([uid]),
      });
    } else {
      await firestore
          .collection('videos')
          .doc(_postId)
          .collection('comments')
          .doc(id)
          .update({
        'likes': FieldValue.arrayUnion([uid]),
      });
    }
  }
}

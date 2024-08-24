import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String id;
  String uid;
  String username;
  Timestamp uploadTimestamp;
  List<Comment> replies;
  String? videoUrl; // Optional video URL
  String? audioUrl; // Optional audio URL
  List likes;
  String profilePhoto;

  Comment(
      {required this.id,
      required this.uid,
      required this.username,
      required this.uploadTimestamp,
      this.replies = const <Comment>[],
      this.videoUrl,
      this.audioUrl,
      this.likes = const [],
      required this.profilePhoto});

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'username': username,
        'id': id,
        'uploadTimestamp': uploadTimestamp,
        'replies': replies.map((reply) => reply.toJson()).toList(), // Convert replies to JSON
        'videoUrl': videoUrl,
        'audioUrl': audioUrl,
        'likes': likes,
        'profilePhoto': profilePhoto,
      };

  static Comment fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    // Convert replies from dynamic to List<Comment>
    List<Comment> replies = (snapshot['replies'] as List<dynamic>?)
        ?.map((reply) => Comment.fromMap(reply as Map<String, dynamic>))
        .toList() ??
        [];
    return Comment(
      uid: snapshot['uid'],
      username: snapshot['username'],
      id: snapshot['id'],
      uploadTimestamp: snapshot['uploadTimestamp'],
      replies: replies,
      videoUrl: snapshot['videoUrl'],
      audioUrl: snapshot['audioUrl'],
      likes: snapshot['likes'],
      profilePhoto: snapshot['profilePhoto'],
    );
  }

  static Comment fromMap(Map<String, dynamic> map) {
    // Utility method to create a Comment from a map
    return Comment(
      id: map['id'],
      uid: map['uid'],
      username: map['username'],
      uploadTimestamp: map['uploadTimestamp'] as Timestamp,
      replies: (map['replies'] as List<dynamic>?)
          ?.map((reply) => Comment.fromMap(reply as Map<String, dynamic>))
          .toList() ??
          [],
      videoUrl: map['videoUrl'],
      audioUrl: map['audioUrl'],
      likes: map['likes'] as List<dynamic>,
      profilePhoto: map['profilePhoto'],
    );
  }

  // factory Comment.fromFirestore(DocumentSnapshot snap) {
  //   var snapshot = snap.data() as Map<String, dynamic>;
  //   return Comment(
  //     id: data['id'],
  //     text: data['text'],
  //     createdAt: (data['createdAt'] as Timestamp).toDate(),
  //   );
  // }
}

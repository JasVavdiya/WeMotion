import 'package:cloud_firestore/cloud_firestore.dart';

class News {
  String id;
  String title;
  String content;
  List<String> media;
  String authorId;
  String authorName;
  String authorProfilePhoto;
  DateTime timestamp;
  List<String> likes;
  int commentCount;

  News({
    required this.id,
    required this.title,
    required this.content,
    required this.media,
    required this.authorId,
    required this.authorName,
    required this.authorProfilePhoto,
    required this.timestamp,
    required this.likes,
    required this.commentCount,
  });

  // Factory method to create a News object from a Firestore document
  factory News.fromDocument(DocumentSnapshot doc) {
    return News(
      id: doc.id,
      title: doc['title'],
      content: doc['content'],
      media: List<String>.from(doc['media']),
      authorId: doc['authorId'],
      authorName: doc['authorName'],
      authorProfilePhoto: doc['authorProfilePhoto'],
      timestamp: (doc['timestamp'] as Timestamp).toDate(),
      likes: List<String>.from(doc['likes']),
      commentCount: doc['commentCount'],
    );
  }
}

class Comment {
  String commentId;
  String audioLink;
  String commentText;
  String profilePhoto;
  String username;
  DateTime timestamp;

  Comment({
    required this.commentId,
    required this.audioLink,
    required this.commentText,
    required this.profilePhoto,
    required this.username,
    required this.timestamp,
  });

  // Factory method to create a Comment object from a Firestore document
  factory Comment.fromDocument(DocumentSnapshot doc) {
    return Comment(
      commentId: doc.id,
      audioLink: doc['audioLink'],
      commentText: doc['commentText'],
      profilePhoto: doc['profilePhoto'],
      username: doc['username'],
      timestamp: (doc['timestamp'] as Timestamp).toDate(),
    );
  }
}

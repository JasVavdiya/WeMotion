import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:video_compress_v2/video_compress_v2.dart';
import 'package:wemotions/constants.dart';
import 'package:wemotions/models/video.dart';

class UploadVideoController extends GetxController {
  _compressVideo(String videoPath) async {
    try{
      final compressedVideo = await VideoCompressV2.compressVideo(
        videoPath,
        quality: VideoQuality.MediumQuality,
      );
      print("Compressed video" + compressedVideo!.file.toString());
      return compressedVideo!.file;
    }catch(e){
      print("/////////"+e.toString());
    }
  }

  Future<String> _uploadVideoToStorage(String id, String videoPath) async {
    Reference ref = firebaseStorage.ref().child('videos').child(id);
    File mediaFile = await _compressVideo(videoPath);
    UploadTask uploadTask = ref.putFile(mediaFile);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  _getThumbnail(String videoPath) async {
    final thumbnail = await VideoCompressV2.getFileThumbnail(videoPath);
    return thumbnail;
  }

  Future<String> _uploadImageToStorage(String id, String videoPath) async {
    Reference ref = firebaseStorage.ref().child('thumbnails').child(id);
    UploadTask uploadTask = ref.putFile(await _getThumbnail(videoPath));
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  // upload video
  uploadVideo(String songName, String caption, String videoPath, List mentions) async {
    try {
      String uid = firebaseAuth.currentUser!.uid;
      DocumentSnapshot userDoc =
      await firestore.collection('users').doc(uid).get();
      // get id
      var allDocs = await firestore.collection('videos').get();
      int len = allDocs.docs.length;
      print("Uid sneh : " + uid);
      String videoUrl = await _uploadVideoToStorage("Video $len", videoPath);
      String thumbnail = await _uploadImageToStorage("Video $len", videoPath);
      Video video = Video(
        username: (userDoc.data()! as Map<String, dynamic>)['name'],
        uid: uid,
        id: "Video $len",
        likes: [],
        commentCount: 0,
        shareCount: 0,
        songName: songName,
        caption: caption,
        videoUrl: videoUrl,
        mentions: mentions,
        profilePhoto: (userDoc.data()! as Map<String, dynamic>)['profilePhoto'],
        thumbnail: thumbnail,
      );

      await firestore.collection('videos').doc('Video $len').set(
        video.toJson(),
      );
      Get.back();
    } catch (e) {
      print("Error Uploading Video"+e.toString());
      Get.snackbar(
        'Error Uploading Video',
        e.toString(),
      );
    }
  }
}

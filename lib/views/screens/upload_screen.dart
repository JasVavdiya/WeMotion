import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class UploadNewsScreen extends StatefulWidget {
  @override
  _UploadNewsScreenState createState() => _UploadNewsScreenState();
}

class _UploadNewsScreenState extends State<UploadNewsScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  List<XFile> _imageFiles = [];
  List<XFile> _videoFiles = [];

  bool _isLoading = false;

  // Method to pick images
  Future<void> _pickImages() async {
    try {
      final List<XFile>? selectedImages = await _picker.pickMultiImage();
      if (selectedImages != null && selectedImages.isNotEmpty) {
        setState(() {
          _imageFiles.addAll(selectedImages);
        });
      }
    } catch (e) {
      print('Error picking images: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking images')),
      );
    }
  }

  // Method to pick videos
  Future<void> _pickVideos() async {
    try {
      final XFile? selectedVideo = await _picker.pickVideo(
        source: ImageSource.gallery,
      );
      if (selectedVideo != null) {
        setState(() {
          _videoFiles.add(selectedVideo);
        });
      }
    } catch (e) {
      print('Error picking video: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking video')),
      );
    }
  }

  // Method to upload news
  Future<void> _uploadNews() async {
    if (_titleController.text.isEmpty ||
        _contentController.text.isEmpty ||
        (_imageFiles.isEmpty && _videoFiles.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields and select media')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Upload media files and get URLs
      List<String> mediaUrls = await _uploadMediaFiles();

      // Get current user info
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      String newsId = Uuid().v4();

      // Create news document
      await FirebaseFirestore.instance.collection('news').doc(newsId).set({
        'title': _titleController.text.trim(),
        'content': _contentController.text.trim(),
        'media': mediaUrls,
        'authorId': currentUser.uid,
        'authorName': currentUser.displayName ?? 'Unknown',
        'authorProfilePhoto': currentUser.photoURL ?? '',
        'timestamp': FieldValue.serverTimestamp(),
        'likes': [],
        'commentCount': 0,
      });

      setState(() {
        _isLoading = false;
        _titleController.clear();
        _contentController.clear();
        _imageFiles.clear();
        _videoFiles.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('News uploaded successfully')),
      );
    } catch (e) {
      print('Error uploading news: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading news')),
      );
    }
  }

  // Method to upload media files to Firebase Storage
  Future<List<String>> _uploadMediaFiles() async {
    List<String> mediaUrls = [];
    FirebaseStorage storage = FirebaseStorage.instance;

    for (XFile image in _imageFiles) {
      String fileId = Uuid().v4();
      Reference ref = storage.ref().child('news/media/$fileId');
      UploadTask uploadTask = ref.putFile(File(image.path));
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      mediaUrls.add(downloadUrl);
    }

    for (XFile video in _videoFiles) {
      String fileId = Uuid().v4();
      Reference ref = storage.ref().child('news/media/$fileId');
      UploadTask uploadTask = ref.putFile(File(video.path));
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      mediaUrls.add(downloadUrl);
    }

    return mediaUrls;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload News'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _contentController,
                  decoration: InputDecoration(
                    labelText: 'Content',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 5,
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: _pickImages,
                      icon: Icon(Icons.photo),
                      label: Text('Add Images'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                    ),
                    SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: _pickVideos,
                      icon: Icon(Icons.videocam),
                      label: Text('Add Video'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                _buildMediaPreview(),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _uploadNews,
                  child: Text('Upload News'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding:
                    EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  // Widget to display selected media previews
  Widget _buildMediaPreview() {
    List<Widget> mediaWidgets = [];

    mediaWidgets.addAll(_imageFiles.map((image) {
      return Stack(
        children: [
          Container(
            width: 100,
            height: 100,
            margin: EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: FileImage(File(image.path)),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _imageFiles.remove(image);
                });
              },
              child: CircleAvatar(
                radius: 12,
                backgroundColor: Colors.black54,
                child: Icon(
                  Icons.close,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      );
    }).toList());

    mediaWidgets.addAll(_videoFiles.map((video) {
      return Stack(
        children: [
          Container(
            width: 100,
            height: 100,
            margin: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Icon(
                Icons.videocam,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _videoFiles.remove(video);
                });
              },
              child: CircleAvatar(
                radius: 12,
                backgroundColor: Colors.black54,
                child: Icon(
                  Icons.close,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      );
    }).toList());

    return mediaWidgets.isEmpty
        ? Container()
        : Wrap(
      children: mediaWidgets,
    );
  }
}

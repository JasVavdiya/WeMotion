import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wemotions/controllers/upload_video_controller.dart';
import 'package:wemotions/views/widgets/text_input_field.dart';
import 'package:video_player/video_player.dart';

class ConfirmScreen extends StatefulWidget {
  final File videoFile;
  final String videoPath;
  const ConfirmScreen({
    Key? key,
    required this.videoFile,
    required this.videoPath,
  }) : super(key: key);

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  late VideoPlayerController controller;
  TextEditingController _songController = TextEditingController();
  TextEditingController _captionController = TextEditingController();
  UploadVideoController uploadVideoController =
  Get.put(UploadVideoController());

  bool _isLoading = false; // Flag to track loading state

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.file(widget.videoFile)
      ..initialize().then((_) {
        setState(() {}); // Rebuild after initialization
        controller.play();
        controller.setVolume(1);
        controller.setLooping(true);
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _uploadVideo() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });
    await uploadVideoController.uploadVideo(
      _songController.text,
      _captionController.text,
      widget.videoPath,
    );
    setState(() {
      _isLoading = false; // Hide loading indicator
    });
    Get.back(); // Navigate back to the previous screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 1.5,
                  child: controller.value.isInitialized
                      ? AspectRatio(aspectRatio: controller.value.aspectRatio,child: VideoPlayer(controller))
                      : const CircularProgressIndicator(), // Show loading indicator while video initializes
                ),
                const SizedBox(
                  height: 30,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        width: MediaQuery.of(context).size.width - 20,
                        child: TextInputField(
                          controller: _songController,
                          labelText: 'Song Name',
                          icon: Icons.music_note,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        width: MediaQuery.of(context).size.width - 20,
                        child: TextInputField(
                          controller: _captionController,
                          labelText: 'Caption',
                          icon: Icons.closed_caption,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: _uploadVideo,
                        child: const Text(
                          'Share!',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(), // Show loading indicator during upload
            ),
        ],
      ),
    );
  }
}

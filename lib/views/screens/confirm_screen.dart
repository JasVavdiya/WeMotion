import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:wemotions/controllers/profile_controller.dart';
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
  final ProfileController profileController = Get.put(ProfileController());

  List<Map<String, String>> _hastiUsers = [];
  List<MultiSelectItem<Map<String, String>>> _dropdownItems = [];
  List<Map<String, String>> _selectedUsers = [];

  Future<void> _fetchHastiUsers() async {
    List<Map<String, String>> users =
    await profileController.getHastiUsernames();
    print(users);
    setState(() {
      _hastiUsers = users;
      _dropdownItems = _hastiUsers
          .map((user) =>
          MultiSelectItem<Map<String, String>>(user, user['username']!))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      controller = VideoPlayerController.file(widget.videoFile);
    });
    controller.initialize();
    controller.videoPlayerOptions?.webOptions?.allowContextMenu;
    controller.play();
    controller.setVolume(1);
    controller.setLooping(true);
    _fetchHastiUsers();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.5,
              child: VideoPlayer(controller),
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
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: MultiSelectDialogField(
                      items: _dropdownItems,
                      title: Text("Select Users"),
                      selectedColor: Colors.blue,
                      itemsTextStyle: TextStyle(color: Colors.white),
                      selectedItemsTextStyle: TextStyle(color: Colors.blue),
                      buttonIcon: Icon(
                        Icons.person_add,
                        color: Colors.blue,
                      ),
                      checkColor: Colors.blue,
                      buttonText: Text(
                        "Select Users",
                        style: TextStyle(
                          color: Colors.blue[800],
                          fontSize: 16,
                        ),
                      ),
                      onConfirm: (List<Map<String, String>> selected) {
                        setState(() {
                          _selectedUsers = selected;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () => uploadVideoController.uploadVideo(
                          _songController.text,
                          _captionController.text,
                          widget.videoPath,
                          _selectedUsers.map((user) => user['uid']!).toList()
                      ),
                      child: const Text(
                        'Share!',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

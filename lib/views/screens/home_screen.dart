import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wemotions/constants.dart';
import 'package:wemotions/views/screens/confirm_screen.dart';
import 'package:wemotions/views/widgets/custom_icon.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int pageIdx = 0;

  pickVideo(ImageSource src, BuildContext context) async {
    final video = await ImagePicker().pickVideo(source: src);
    if (video != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ConfirmScreen(
            videoFile: File(video.path),
            videoPath: video.path,
          ),
        ),
      );
    }
  }

  showOptionsDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        children: [
          SimpleDialogOption(
            onPressed: () => pickVideo(ImageSource.gallery, context),
            child: Row(
              children: const [
                Icon(Icons.image),
                Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Text(
                    'Gallery',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () => pickVideo(ImageSource.camera, context),
            child: Row(
              children: const [
                Icon(Icons.camera_alt),
                Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Text(
                    'Camera',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.of(context).pop(),
            child: Row(
              children: const [
                Icon(Icons.cancel),
                Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Text(
                    'Cancel',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  setState(() {
                    pageIdx = 0;
                  });
                },
                // child: Icon(
                //   Icons.home,
                //   color: pageIdx == 0 ? Colors.blue : Colors.white,
                //   size: 30,
                // ),
                child: Text("We",style: TextStyle(color: pageIdx == 0 ? Colors.blue : Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    pageIdx = 1;
                  });
                },
                child: Icon(
                  FontAwesomeIcons.magnifyingGlass,
                  color: pageIdx == 1 ? Colors.blue : Colors.white,
                  size: 20,
                ),
              ),
              GestureDetector(
                onTap: () {
                  showOptionsDialog(context);
                },
                child: CustomIcon(),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    pageIdx = 3;
                  });
                },
                child: FaIcon(
                  CupertinoIcons.flame,
                  color: pageIdx == 3 ? Colors.red[600] : Colors.white,
                  size: 24,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    pageIdx = 4;
                  });
                },
                child: Icon(
                  FontAwesomeIcons.userAstronaut,
                  color: pageIdx == 4 ? Colors.blue : Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
      ),
      body: pages[pageIdx],
    );
  }
}

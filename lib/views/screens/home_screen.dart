import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wemotions/views/screens/confirm_screen.dart';
import 'package:wemotions/views/widgets/custom_icon.dart';

import '../../constants.dart';

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
      floatingActionButtonLocation: CustomFloatingActionButtonLocation(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.transparent,
        onPressed: () {
          showOptionsDialog(context);
        },
        child: CustomIcon(),
      ),
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.only(left: 30, right: 30),
        notchMargin: 5,
        shape: CircularNotchedRectangle(),
        color: Colors.grey.shade900,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                setState(() {
                  pageIdx = 0;
                });
              },
              child: Text(
                "We",
                style: TextStyle(
                  color: pageIdx == 0 ? Colors.blue : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
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
                size: 22,
              ),
            ),
            SizedBox(width: 45),
            GestureDetector(
              onTap: () {
                setState(() {
                  pageIdx = 3;
                });
              },
              child: FaIcon(
                CupertinoIcons.flame,
                color: pageIdx == 3 ? Colors.red[600] : Colors.white,
                size: 26,
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
                size: 22,
              ),
            ),
          ],
        ),
      ),
      body: pages[pageIdx],
    );
  }
}

class CustomFloatingActionButtonLocation extends FloatingActionButtonLocation {
  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    // Center the FAB horizontally
    final double fabX = (scaffoldGeometry.scaffoldSize.width - scaffoldGeometry.floatingActionButtonSize.width) / 2;

    // Position it slightly lower than the default
    final double fabY = scaffoldGeometry.scaffoldSize.height - 60 - scaffoldGeometry.floatingActionButtonSize.height / 4;

    return Offset(fabX, fabY);
  }
}

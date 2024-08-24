import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import '../../controllers/comment_controller.dart';
import '../widgets/comment_widget.dart';

class CommentSection extends StatefulWidget {
  final String id;

  CommentSection({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  late final RecorderController recorderController;
  CommentController commentController = Get.put(CommentController());
  String? path;
  String? musicFile;
  bool isRecording = false;
  bool isRecordingCompleted = false;
  bool isLoading = true;
  late Directory appDirectory;

  @override
  void initState() {
    super.initState();
    _getDir();
    _initialiseControllers();
  }

  void _getDir() async {
    final directory = await getApplicationDocumentsDirectory();
    appDirectory = await getApplicationDocumentsDirectory();
    path = "${directory.path}/${DateTime.now().millisecondsSinceEpoch}.m4a";
    isLoading = false;
    setState(() {});
  }

  void _initialiseControllers() {
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 44100;
  }

  // void _pickFile() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles();
  //   if (result != null) {
  //     musicFile = result.files.single.path;
  //     setState(() {});
  //   } else {
  //     debugPrint("File not picked");
  //   }
  // }

  @override
  void dispose() {
    recorderController.dispose();
    super.dispose();
  }


  void _startOrStopRecording() async {
    try {
      if (await recorderController.checkPermission()) {
        if (isRecording) {
          recorderController.reset();
          path = await recorderController.stop(false);
          if (path != null) {
            isRecordingCompleted = true;
            commentController.postComment(path!);
            Get.snackbar(
                'Audio posted successfully',
                "enjoy!"
            );
            debugPrint(path);
            debugPrint("Recorded file size: ${File(path!).lengthSync()}");
          }
        } else {
          await recorderController.record(path: path); // Path is optional
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() {
        isRecording = !isRecording;
      });
    }
  }

  void _refreshWave() {
    if (isRecording) recorderController.refresh();
  }

  @override
  Widget build(BuildContext context) {
    commentController.updatePostId(widget.id);
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : SafeArea(
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Obx(
                  () => Container(
                color: Colors.grey[900],
                child: ListView.builder(
                  itemCount: commentController.comments.length,
                  itemBuilder: (context, index) {
                    final comment = commentController.comments[index];
                    return CommentWidget(comment: comment);
                  },
                ),
              ),
            ),
            Positioned(
              bottom: 30.0,
              right: 100,
              child: Row(
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: isRecording
                        ? AudioWaveforms(
                      enableGesture: true,
                      size: Size(
                          MediaQuery.of(context).size.width / 2,
                          50),
                      recorderController: recorderController,
                      waveStyle: const WaveStyle(
                        waveColor: Colors.white,
                        extendWaveform: true,
                        showMiddleLine: false,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: Colors.blue,
                      ),
                      padding: const EdgeInsets.only(left: 18),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15),
                    )
                        : SizedBox(
                      height: 50,
                    ),
                  ),
                  if(isRecording)...{
                    IconButton(
                      onPressed: _refreshWave,
                      icon: Icon(
                        Icons.refresh,
                        color: Colors.white,
                      ),
                    )
                  },
                ],
              ),),
            Positioned(
              bottom: 30.0,
              right: 20,
              child: FloatingActionButton(
                backgroundColor: Colors.blue,
                onPressed: _startOrStopRecording,
                child: Icon(isRecording ? Icons.stop : Icons.mic,size: 30,),
              ),
            ),
          ],
        )
      ),
    );
  }

}
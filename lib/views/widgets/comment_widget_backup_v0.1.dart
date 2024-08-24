import 'dart:io';
import 'dart:async';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import '../../models/comment.dart';

class CommentWidget extends StatefulWidget {
  Comment comment;


  CommentWidget({required this.comment});

  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  // late VideoPlayerController? _videoController;
  File? file;

  late PlayerController controller;
  late StreamSubscription<PlayerState> playerStateSubscription;

  final playerWaveStyle = const PlayerWaveStyle(
    fixedWaveColor: Colors.white54,
    liveWaveColor: Colors.blue,
    spacing: 6,

  );

  @override
  void initState() {
    super.initState();
    // if (widget.comment.videoUrl != null) {
    //   _videoController = VideoPlayerController.networkUrl(Uri.parse(widget.comment.videoUrl!))
    //     ..initialize().then((_) => setState(() {}));
    // } else {
    //   _videoController = null;
    // }

    if (widget.comment.audioUrl != null) {
      controller = PlayerController();
      _preparePlayer();
      playerStateSubscription = controller.onPlayerStateChanged.listen((_) {
        setState(() {});
      });
    }
  }

  void _preparePlayer() async {
    // Opening file from assets folder
    if (widget.comment.audioUrl != null) {
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/temp_audio.mp4';
      final file = File(filePath);

      // Download the audio file
      await _downloadFile(widget.comment.audioUrl!, file);
      // Prepare player with extracting waveform
      controller.preparePlayer(
        path: filePath,
        shouldExtractWaveform:  true,
      );
    }
    if (widget.comment.audioUrl == null) {
      return;
    }
  }

  Future<void> _downloadFile(String url, File file) async {
    final response = await HttpClient().getUrl(Uri.parse(url));
    final bytes = await response.close().then((res) => res.toBytes());
    await file.writeAsBytes(bytes);
  }

  @override
  void dispose() {
    // _videoController?.dispose();
    controller.dispose();
    playerStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black26,
      margin: EdgeInsets.only(top: 5,bottom: 5),
      padding: EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(width:35,height:35,child: ClipRRect(borderRadius: BorderRadius.circular(50),child: Image.network(widget.comment.profilePhoto,fit: BoxFit.contain))),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.comment.username,style: TextStyle(color: Colors.white),),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () async {
                                  if (controller.playerState.isPlaying) {
                                    await controller.pausePlayer();
                                  } else {
                                    await controller.startPlayer(forceRefresh: true,finishMode: FinishMode.pause);
                                  }
                                  setState(() {});
                                },
                                icon: Icon(
                                  controller.playerState.isPlaying
                                      ? Icons.stop
                                      : Icons.play_arrow,
                                ),
                                color: Colors.white,
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                              ),
                              AudioFileWaveforms(
                                size: Size(MediaQuery.of(context).size.width / 1.5, 70),
                                playerController: controller,
                                waveformType:WaveformType.fitWidth,
                                playerWaveStyle: playerWaveStyle,
                              ),
                            ],
                          ),
                          // Padding(
                          //   padding: EdgeInsets.only(left: 50.0),
                          //   child: Column(
                          //     children: widget.comment.replies
                          //         .map((reply) => CommentWidget(comment: reply, onReply: widget.onReply))
                          //         .toList(),
                          //   ),
                          // ),
                          GestureDetector(
                            onTap: (){

                            },
                            child: Text(
                              "Reply",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ])
                ),
              )
              
            ],
          ),
        ],
      ),
    );
  }

  // Widget _buildVideoPlayer() {
  //   return _videoController != null && _videoController!.value.isInitialized
  //       ? AspectRatio(
  //     aspectRatio: _videoController!.value.aspectRatio,
  //     child: VideoPlayer(_videoController!),
  //   )
  //       : Container(child: Text("Loading video..."));
  // }

}

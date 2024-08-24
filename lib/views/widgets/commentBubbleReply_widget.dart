import 'dart:async';
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:path_provider/path_provider.dart';

import '../../models/comment.dart';


class CommentBubbleReplyWidget extends StatefulWidget {
  final Comment comment;
  final ValueChanged<Comment>? onReply;
  final Comment parentComment;
  final ValueChanged<String>? onReplyDisplayName;
  CommentBubbleReplyWidget({required this.comment, this.onReply,required this.parentComment, this.onReplyDisplayName,});

  @override
  State<CommentBubbleReplyWidget> createState() => _CommentBubbleReplyWidgetState();
}

class _CommentBubbleReplyWidgetState extends State<CommentBubbleReplyWidget> {

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
    if (widget.comment.audioUrl != null) {
      controller = PlayerController();
      _preparePlayer();
      playerStateSubscription = controller.onPlayerStateChanged.listen((_) {
        setState(() {});
      });
    }
  }

  void _preparePlayer() async {
    if (widget.comment.audioUrl != null) {
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/temp_audio.mp4';
      final file = File(filePath);

      await _downloadFile(widget.comment.audioUrl!, file);
      controller.preparePlayer(
        path: filePath,
        shouldExtractWaveform: true,
      );
    }
  }

  Future<void> _downloadFile(String url, File file) async {
    final response = await HttpClient().getUrl(Uri.parse(url));
    final bytes = await response.close().then((res) => res.toBytes());
    await file.writeAsBytes(bytes);
  }

  @override
  void dispose() {
    controller.dispose();
    playerStateSubscription.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.all(10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(widget.comment.username,
                          style: TextStyle(color: Colors.white)),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () async {
                              if (controller.playerState.isPlaying) {
                                await controller.pausePlayer();
                              } else {
                                await controller.startPlayer(
                                    forceRefresh: true,
                                    finishMode: FinishMode.pause);
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
                            size: Size(
                                MediaQuery.of(context).size.width / 1.5,
                                70),
                            playerController: controller,
                            waveformType: WaveformType.fitWidth,
                            playerWaveStyle: playerWaveStyle,
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          if (widget.onReply != null) {
                            widget.onReply!(widget.parentComment);
                            widget.onReplyDisplayName!(widget.comment.username);
                          }
                        },
                        child: Text(
                          "Reply",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ])),
          ),
          SizedBox(width: 10),
          Container(
              width: 35,
              height: 35,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(widget.comment.profilePhoto,
                      fit: BoxFit.contain))),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import '../../models/comment.dart';

class CommentWidget extends StatefulWidget {
  Comment comment;
  Function(String parentId, String content, String? videoUrl, String? audioUrl)? onReply;

  CommentWidget({required this.comment,this.onReply});

  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  // late VideoPlayerController? _videoController;
  late AudioPlayer? _audioPlayer;

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
      _audioPlayer = AudioPlayer();
    } else {
      _audioPlayer = null;
    }
  }

  @override
  void dispose() {
    // _videoController?.dispose();
    _audioPlayer?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black45,
      margin: EdgeInsets.only(top: 5,bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ListTile(
          //   leading: ClipRRect(borderRadius: BorderRadius.circular(50),child: Image.network(widget.comment.profilePhoto,fit: BoxFit.contain)),
          //   title: Text(widget.comment.username),
          //   // subtitle:widget.comment.videoUrl != null
          //   //     ? _buildVideoPlayer()
          //   //     : _buildAudioPlayer(),
          //   subtitle:_buildAudioPlayer(),
          //   // trailing: Text(
          //   //   "${widget.comment.uploadTimestamp.}",
          //   //   style: TextStyle(fontSize: 12),
          //   // ),
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(width:50,height:50,child: ClipRRect(borderRadius: BorderRadius.circular(50),child: Image.network(widget.comment.profilePhoto,fit: BoxFit.contain))),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(30)
                  ),
                  margin: EdgeInsets.all(10),
                  height: 200,
                  child: Text("data"),
                ),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 50.0),
            child: Column(
              children: widget.comment.replies
                  .map((reply) => CommentWidget(comment: reply, onReply: widget.onReply))
                  .toList(),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 60.0, bottom: 10.0),
          //   child: GestureDetector(
          //     onTap: () => _showReplyDialog(context, widget.comment.id),
          //     child: Text(
          //       "Reply",
          //       style: TextStyle(color: Colors.blue),
          //     ),
          //   ),
          // ),
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

  Widget _buildAudioPlayer() {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.play_arrow),
          onPressed: () async {
            await _audioPlayer?.play(UrlSource(widget.comment.audioUrl!));
          },
        ),
        Text("Audio Message"),
      ],
    );
  }

  void _showReplyDialog(BuildContext context, String parentId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Reply"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ElevatedButton(
              //   onPressed: () async {
              //     // Implement video recording or picking logic here
              //     // String videoUrl = "your_video_url"; // Replace with actual video URL
              //     // widget.onReply(parentId, "", videoUrl, null);
              //     // Navigator.of(context).pop();
              //   },
              //   child: Text("Reply with Video"),
              // ),
              ElevatedButton(
                onPressed: () async {
                  // Implement audio recording or picking logic here
                  // String audioUrl = "your_audio_url"; // Replace with actual audio URL
                  // widget.onReply(parentId, "", null, audioUrl);
                  // Navigator.of(context).pop();
                },
                child: Text("Reply with Audio"),
              ),
            ],
          ),
        );
      },
    );
  }
}

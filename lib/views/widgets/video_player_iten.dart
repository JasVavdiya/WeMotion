import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerItem({
    Key? key,
    required this.videoUrl,
  }) : super(key: key);

  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController videoPlayerController;

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((value) {
        setState(() {}); // Trigger a rebuild to hide the loader once initialized
        videoPlayerController.play();
        videoPlayerController.setLooping(true);
      });
  }

  void stopVideo() {
    videoPlayerController.pause();
  }

  void startVideo() {
    videoPlayerController.play();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onLongPressDown: (longDown) {
        stopVideo();
      },
      onLongPressUp: () {
        startVideo();
      },
      child: Stack(
        alignment: Alignment.center, // Center the loader
        children: [
          Container(
            width: size.width,
            height: size.height,
            decoration: const BoxDecoration(
              color: Colors.black,
            ),
            child: videoPlayerController.value.isInitialized
                ?Center(
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: SizedBox(
                    width: videoPlayerController.value.size.width,
                    height: videoPlayerController.value.size.height,
                    child: VideoPlayer(videoPlayerController),
                  ),
                ))
                : const SizedBox.shrink(), // Placeholder while the video is loading
          ),
          if (!videoPlayerController.value.isInitialized)
            const CircularProgressIndicator(color: Colors.blue,), // Show loader while the video is loading
        ],
      ),
    );
  }
}

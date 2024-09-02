import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';
import 'package:wemotions/views/screens/comment_screen.dart';
import 'package:wemotions/views/widgets/circle_animation.dart';

class SingleVideoScreen extends StatelessWidget {
  final List<Map<String, dynamic>> videoList;

  SingleVideoScreen({Key? key, required this.videoList}) : super(key: key);

  Widget buildProfile(String profilePhoto) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Stack(children: [
        // Positioned(
        //   left: 5,
        //   child: Container(
        //     width: 50,
        //     height: 50,
        //     padding: const EdgeInsets.all(1),
        //     decoration: BoxDecoration(
        //       color: Colors.white,
        //       borderRadius: BorderRadius.circular(25),
        //     ),
        //     child: ClipRRect(
        //       borderRadius: BorderRadius.circular(25),
        //       child: Image.network(
        //         profilePhoto,
        //         fit: BoxFit.cover,
        //       ),
        //     ),
        //   ),
        // )
      ]),
    );
  }

  Widget buildMusicAlbum(String profilePhoto) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(11),
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.grey, Colors.white],
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image.network(
                profilePhoto,
                fit: BoxFit.cover,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      // appBar: AppBar(
      //   leading: IconButton(
      //     icon: Icon(Icons.arrow_back),
      //     onPressed: () => Navigator.of(context).pop(),
      //   ),
      //   title: Text('Videos'),
      //   backgroundColor: Colors.black,
      // ),
      body: PageView.builder(
        itemCount: videoList.length,
        controller: PageController(initialPage: 0, viewportFraction: 1),
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          final data = videoList[index]['videoData'];
          return Stack(
            children: [
              VideoPlayerItem(
                videoUrl: data['videoUrl'],
              ),
              Column(
                children: [
                  const SizedBox(height: 100),
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(left: 20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  data['username'] ?? 'Username',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  data['caption'] ?? 'Caption',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.music_note,
                                      size: 15,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      data['songName'] ?? 'Song Name',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 100,
                          margin: EdgeInsets.only(top: size.height / 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              buildProfile(data['profilePhoto']),
                              Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      // Add like functionality here
                                    },
                                    child: Icon(
                                      CupertinoIcons.capslock,
                                      size: 32,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 1),
                                  Text(
                                    videoList[index]['likes'] != null ?  videoList[index]['likes'] : "0",
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => CommentSection(
                                            id: videoList[index]['videoId'],
                                            type: 'videos',
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Icon(
                                      CupertinoIcons.chat_bubble_text,
                                      size: 32,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 1),
                                  Text(
                                    data['commentCount'].toString(),
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      // Add share functionality here
                                    },
                                    child: const Icon(
                                      CupertinoIcons.arrow_turn_down_right,
                                      size: 32,
                                      color: Colors.white,
                                    ),
                                  ),
                                  // const SizedBox(height: 7),
                                  Text(
                                    data['shareCount'].toString(),
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              CircleAnimation(
                                child: buildMusicAlbum(data['profilePhoto']),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 25,
                left: 15,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(100)
                  ),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white,),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

class VideoPlayerItem extends StatelessWidget {
  final String videoUrl;

  VideoPlayerItem({Key? key, required this.videoUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VideoPlayerWidget(
      videoUrl: videoUrl,
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  VideoPlayerWidget({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {
          _isVideoInitialized = true;
        });
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVideoInitialized) {
      return Center(child: CircularProgressIndicator());
    }
    // return Center(child: AspectRatio(aspectRatio: _controller.value.aspectRatio,child: VideoPlayer(_controller)));
    return Center(child: AspectRatio(aspectRatio: _controller.value.aspectRatio,child: VideoPlayer(_controller)));
  }
}

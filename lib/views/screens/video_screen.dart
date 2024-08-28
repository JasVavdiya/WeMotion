import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wemotions/constants.dart';
import 'package:wemotions/controllers/video_controller.dart';
import 'package:wemotions/views/screens/SingleVideoScreen.dart';
import 'package:wemotions/views/screens/comment_screen.dart';
import 'package:wemotions/views/widgets/video_player_iten.dart';
import 'package:get/get.dart';

class VideoScreen extends StatelessWidget {
  VideoScreen({Key? key}) : super(key: key);

  final VideoController videoController = Get.put(VideoController());

  buildProfile(String profilePhoto) {
    return SizedBox(
      width: 30,
      height: 30,
      child: Stack(children: [
        Positioned(
          child: Container(
            width: 30,
            height: 30,
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image(
                image: NetworkImage(profilePhoto),
                fit: BoxFit.cover,
              ),
            ),
          ),
        )
      ]),
    );
  }

  // buildMusicAlbum(String profilePhoto) {
  //   return SizedBox(
  //     width: 60,
  //     height: 60,
  //     child: Column(
  //       children: [
  //         Container(
  //             padding: EdgeInsets.all(11),
  //             height: 50,
  //             width: 50,
  //             decoration: BoxDecoration(
  //                 gradient: const LinearGradient(
  //                   colors: [
  //                     Colors.grey,
  //                     Colors.white,
  //                   ],
  //                 ),
  //                 borderRadius: BorderRadius.circular(25)),
  //             child: ClipRRect(
  //               borderRadius: BorderRadius.circular(25),
  //               child: Image(
  //                 image: NetworkImage(profilePhoto),
  //                 fit: BoxFit.cover,
  //               ),
  //             ))
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Obx(() {
        return PageView.builder(
          itemCount: videoController.videoList.length,
          controller: PageController(initialPage: 0, viewportFraction: 1),
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            final data = videoController.videoList[index];
            return Stack(
              children: [
                // VideoPlayerItem(
                //   videoUrl: data.videoUrl,
                // ),
                VideoPlayerWidget(
                  videoUrl: data.videoUrl,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(
                          left: 15,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              children: [
                                buildProfile(
                                  data.profilePhoto,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  data.username,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              data.caption,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.music_note,
                                  size: 15,
                                  color: Colors.white,
                                ),
                                Text(
                                  data.songName,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 60,
                      margin: EdgeInsets.only( bottom: size.height / 18),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Column(
                            children: [
                              InkWell(
                                onTap: () =>
                                    videoController.likeVideo(data.id),
                                child: Icon(
                                  data.likes.contains(
                                      authController.user.uid) ? CupertinoIcons.capslock_fill : CupertinoIcons.capslock,
                                  size: 35,
                                  color:data.likes.contains(
                                      authController.user.uid) ? Colors.blue : Colors.white,
                                ),
                              ),
                              const SizedBox(height: 1),
                              if(data.likes.length != 0)...{
                                Text(
                                  data.likes.length.toString(),
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.white,
                                  ),
                                )
                              }else...{
                                Text(
                                 " ",
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.white,
                                  ),
                                )
                              }


                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Column(
                            children: [
                              InkWell(
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => CommentSection(
                                      id: data.id,
                                    ),
                                  ),
                                ),
                                child: const Icon(
                                  CupertinoIcons.chat_bubble_text,
                                  size: 32,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 1),

                              if(data.commentCount != 0)...{
                                Text(
                                  data.commentCount.toString(),
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.white,
                                  ),
                                )
                              }else...{
                                Text(
                                  " ",
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.white,
                                  ),
                                )
                              }

                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Column(
                            children: [
                              InkWell(
                                onTap: () {},
                                child: const Icon(
                                  CupertinoIcons.arrow_turn_down_right,
                                  size: 32,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 7),
                              if(data.shareCount != 0)...{
                                Text(
                                  data.shareCount.toString(),
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.white,
                                  ),
                                )
                              }else...{
                                Text(
                                  " ",
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.white,
                                  ),
                                )
                              }

                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () {},
                            child: const Icon(
                              CupertinoIcons.ellipsis,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                          // CircleAnimation(
                          //   child: buildMusicAlbum(data.profilePhoto),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      }),
    );
  }
}

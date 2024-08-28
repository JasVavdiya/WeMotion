import 'package:flutter/material.dart';
import 'package:wemotions/controllers/home_controller.dart';
import 'package:get/get.dart';
import 'package:wemotions/views/screens/SingleVideoScreen.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final HomeController homeController = Get.put(HomeController());
  List<Map<String, dynamic>> _userProfilesWithVideos = [];

  Future<void> _fetchAndStoreData() async {
    List<Map<String, dynamic>> data =
        await homeController.getHastiUsersWithMentionedVideos();
    setState(() {
      _userProfilesWithVideos = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchAndStoreData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _userProfilesWithVideos.length == 0
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                    itemCount: _userProfilesWithVideos.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final userProfile = _userProfilesWithVideos[index];
                      return Container(
                        margin: EdgeInsets.only(left: 12, right: 12, bottom: 10, top: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 42,
                                  width: 42,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: Image.network(
                                      userProfile['profilePhoto'] ?? '',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  userProfile['username'] ?? '',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: 250,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: userProfile['mentionedVideos'].length,
                                itemBuilder: (context, videoIndex) {
                                  final single = userProfile['mentionedVideos'][videoIndex]['videoData'];
                                  final video = userProfile['mentionedVideos'][videoIndex]['videoData']['thumbnail'];
                                  final thumbnail = single['thumbnail'];
                                  final videoUrl = single['videoUrl']; // Assuming you need the videoUrl for the VideoScreen
                                  final profilePhoto = single['profilePhoto'];
                                  final username = single['username'];
                                  final caption = single['caption'];
                                  final songName = single['songName'];
                                  final likes = single['likes'];
                                  final commentCount = single['commentCount'];
                                  final shareCount = single['shareCount'];
                                  return Stack(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => SingleVideoScreen(
                                                videoList: [
                                                  {
                                                    'videoId': userProfile['mentionedVideos'][videoIndex]['videoId'],
                                                    'videoData': {
                                                      'videoUrl': videoUrl,
                                                      'profilePhoto': profilePhoto,
                                                      'username': username,
                                                      'caption': caption,
                                                      'songName': songName,
                                                      'thumbnail': thumbnail,
                                                      'likes': likes,
                                                      'commentCount': commentCount,
                                                      'shareCount': shareCount
                                                    }
                                                  }
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          width: 140,
                                          height: 250,
                                          margin: EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: Colors.grey.shade50.withAlpha(30),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(10),
                                            child: Image.network(
                                              video,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        child: Icon(Icons.play_arrow_outlined, color: Colors.white),
                                        top: 115,
                                        left: 65,
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:wemotions/controllers/trending_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wemotions/views/screens/SingleVideoScreen.dart';

class TrendingScreen extends StatefulWidget {
  const TrendingScreen({super.key});

  @override
  State<TrendingScreen> createState() => _TrendingScreenState();
}

class _TrendingScreenState extends State<TrendingScreen> {

  final TrendingController trendingController = Get.put(TrendingController());
  late Future<List<Map<String, dynamic>>> _trendingVideos;

  @override
  void initState() {
    super.initState();
    _trendingVideos = trendingController.fetchTrendingVideos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trending Videos"),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _trendingVideos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error fetching trending videos"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No trending videos found"));
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: MasonryGridView.count(
                crossAxisCount: 2,
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  final video = snapshot.data![index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SingleVideoScreen(
                            videoList: [
                              {
                                'videoId': video['id'],
                                'videoData': {
                                  'videoUrl': video['videoUrl'],
                                  'profilePhoto': video['profilePhoto'],
                                  'username': video['username'],
                                  'caption': video['caption'],
                                  'songName': video['songName'],
                                  'thumbnail': video['thumbnail'],
                                  'likes': video['likes'],
                                  'commentCount': video['commentCount'],
                                  'shareCount': video['shareCount'],
                                },
                              }
                            ],
                          ),
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            video['thumbnail'],
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: Icon(
                            Icons.play_circle_fill,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                // staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
            );
          }
        },
      ),
    );
  }
}

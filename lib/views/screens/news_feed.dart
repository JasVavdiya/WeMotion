import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wemotions/constants.dart';
import 'package:wemotions/controllers/new_controller.dart';
import 'package:wemotions/models/news.dart';
import 'package:get/get.dart';
import 'package:wemotions/views/screens/comment_screen_backup_v0.1.dart';
import 'package:wemotions/views/widgets/media_carousel.dart';

class NewsScreen extends StatefulWidget {
  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final NewsController newsController = Get.put(NewsController());

  late Future<List<News>> _newsFuture;

  @override
  void initState() {
    super.initState();
    _newsFuture = newsController.fetchNewsArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('News Motion')),
      body: FutureBuilder<List<News>>(
        future: _newsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching news'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No news available'));
          } else {
            final newsList = snapshot.data!;
            return ListView.builder(
              itemCount: newsList.length,
              itemBuilder: (context, index) {
                final news = newsList[index];
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  child: Column(
                    children: [
                      newsList.length != 0 && newsList.length != 1 && index != 0
                          ? Column(
                              children: [
                                Divider(
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            )
                          : Container(),
                      Row(
                        children: [
                          Container(
                            height: 42,
                            width: 42,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: Image.network(
                                news.authorProfilePhoto ?? '',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            news.authorName ?? '',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            news.title,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                            textAlign: TextAlign.start,
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      MediaCarousel(mediaUrls: news.media),
                      // SizedBox(height: 10,),
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(news.content)),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                newsController.likeNews(news.id);
                                if (news.likes
                                    .contains(authController.user.uid)) {
                                  news.likes.remove(authController.user.uid);
                                } else {
                                  news.likes.add(authController.user.uid);
                                }
                                setState(() {});
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    news.likes.contains(authController.user.uid)
                                        ? FontAwesomeIcons.solidHeart
                                        : FontAwesomeIcons.heart,
                                    size: 16,
                                    color: news.likes
                                            .contains(authController.user.uid)
                                        ? Colors.red
                                        : Colors.white,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(news.likes.length.toString())
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            InkWell(
                              onTap: () =>
                                  Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => CommentSection(
                                  id: news.id,
                                  type: 'news',
                                ),
                              )),
                              child: Row(
                                children: [
                                  Icon(
                                    FontAwesomeIcons.comment,
                                    size: 16,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(news.commentCount.toString())
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

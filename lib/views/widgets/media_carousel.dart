import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class MediaCarousel extends StatelessWidget {
  final List<String> mediaUrls; // List of media URLs (images/videos)

  MediaCarousel({required this.mediaUrls});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: mediaUrls.length,
      itemBuilder: (context, index, realIndex) {
        final mediaUrl = mediaUrls[index];

        return Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                mediaUrl,
                fit: BoxFit.cover,
                height: 160,
                width: double.infinity,
              ),
            ),
            // Positioned(
            //   bottom: 8,
            //   right: 8,
            //   child: Icon(
            //     Icons.play_circle_fill, // Use appropriate icon if it's a video
            //     color: Colors.white,
            //     size: 30,
            //   ),
            // ),
            // Container(
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(10),
            //     // gradient: LinearGradient(
            //     //   begin: Alignment.topCenter,
            //     //   end: Alignment.bottomCenter,
            //     //   colors: [
            //     //     Colors.transparent,
            //     //     Colors.black.withOpacity(0.7),
            //     //   ],
            //     // ),
            //   ),
            // ),
          ],
        );
      },
      options: CarouselOptions(
        height: 180, // Adjust the height as needed
        aspectRatio: 16 / 9,
        viewportFraction: 0.8,
        initialPage: 0,
        enableInfiniteScroll: false,
        reverse: false,
        autoPlay: false,
        autoPlayInterval: Duration(seconds: 3),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}

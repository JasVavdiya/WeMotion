import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wemotions/constants.dart';
import 'package:wemotions/views/widgets/custom_icon.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int pageIdx = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  setState(() {
                    pageIdx = 1;
                  });
                },
                child: Icon(
                  FontAwesomeIcons.house,
                  color: pageIdx == 1 ? Colors.blue : Colors.white,
                  size: 20,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    pageIdx = 0;
                  });
                },
                // child: Icon(
                //   Icons.home,
                //   color: pageIdx == 0 ? Colors.blue : Colors.white,
                //   size: 30,
                // ),
                child: Text("We",style: TextStyle(color: pageIdx == 0 ? Colors.blue : Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    pageIdx = 2;
                  });
                },
                child: CustomIcon(),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    pageIdx = 3;
                  });
                },
                child: FaIcon(
                  FontAwesomeIcons.arrowTrendUp,
                  color: pageIdx == 3 ? Colors.blue : Colors.white,
                  size: 20,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    pageIdx = 4;
                  });
                },
                child: Icon(
                  FontAwesomeIcons.userAstronaut,
                  color: pageIdx == 4 ? Colors.blue : Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
      ),
      body: pages[pageIdx],
    );
  }
}

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
      bottomNavigationBar: BottomAppBar(
        notchMargin: 5,
        shape: const CircularNotchedRectangle(),
        color: Colors.grey[900],
        padding: EdgeInsets.only(left: 30,right: 30),
        height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  setState(() {
                    pageIdx = 1;
                  });
                },
                child: Icon(
                  FontAwesomeIcons.houseChimneyWindow,
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
              SizedBox(
                width: 30,
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
                  FontAwesomeIcons.newspaper,
                  color: pageIdx == 4 ? Colors.blue : Colors.white,
                  size: 20,
                ),
              ),
              // GestureDetector(
              //   onTap: () {
              //     setState(() {
              //       pageIdx = 5;
              //     });
              //   },
              //   child: Icon(
              //     FontAwesomeIcons.userAstronaut,
              //     color: pageIdx == 5 ? Colors.blue : Colors.white,
              //     size: 20,
              //   ),
              // ),
            ],
          ),
      ),
      body: pages[pageIdx],
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.transparent,
        onPressed: () {
          setState(() {
            pageIdx = 2;
          });
        },
        child: CustomIcon(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

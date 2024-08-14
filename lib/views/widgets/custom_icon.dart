import 'package:flutter/material.dart';

class CustomIcon extends StatelessWidget {
  const CustomIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 45,
      height: 45,
      child: Stack(
        children: [
          Center(
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.blue.shade300,
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
          Center(
            child: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: Colors.blue.shade600,
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
          Center(
            child: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(
                Icons.add,
                color: Colors.black,
                size: 20,
              ),
            ),
          )
        ],
      ),
    );
  }
}

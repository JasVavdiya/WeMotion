import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:wemotions/views/screens/add_video_screen.dart';
import 'package:wemotions/views/screens/first_screen.dart';
import 'package:wemotions/views/screens/profile_screen.dart';
import 'package:wemotions/views/screens/search_screen.dart';
import 'package:wemotions/views/screens/trending_screen.dart';
import 'package:wemotions/views/screens/video_screen.dart';

import 'controllers/auth_controller.dart';
List pages = [
  VideoScreen(),
  FirstScreen(),
  const AddVideoScreen(),
  TrendingScreen(),
  ProfileScreen(uid: authController.user.uid),
];

// COLORS
const backgroundColor = Colors.black;
var buttonColor = Colors.blue[400];
const borderColor = Colors.grey;

//FIREBASE
var firebaseAuth = FirebaseAuth.instance;
var firebaseStorage = FirebaseStorage.instance;
var firestore = FirebaseFirestore.instance;

// CONTROLLER
var authController = AuthController.instance;

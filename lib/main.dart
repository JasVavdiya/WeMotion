import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wemotions/constants.dart';
import 'package:wemotions/views/screens/auth/login_screen.dart';

import 'controllers/auth_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: 'AIzaSyD_yDkKU5BEpQtXWqjalfRvKk172la3KRs',
        appId: '1:369547636653:android:c11f738e1f1ff4b18ffb24',
        messagingSenderId: '1234567890',
        projectId: 'wemotion-91677',
        storageBucket: 'wemotion-91677.appspot.com',
      )
  ).then((value) {
    Get.put(AuthController());
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'WeMotions',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor
      ),
      home: LoginScreen(),
    );
  }
}


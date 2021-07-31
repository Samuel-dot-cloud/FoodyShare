import 'package:flutter/material.dart';
import 'package:food_share/Viewmodel/bottom_nav.dart';
import 'package:food_share/screens/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recipe Share App',
      home: BottomNav(),
    );
  }
}


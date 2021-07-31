import 'package:flutter/material.dart';
import 'package:food_share/Viewmodel/bottom_nav.dart';
import 'package:food_share/screens/home_page.dart';
import 'package:food_share/screens/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FoodyShare',
      theme: ThemeData(
        textTheme:
            GoogleFonts.josefinSansTextTheme(Theme.of(context).textTheme),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        'ForgotPassword': (context) => const ForgotPassword(),
      },
    );
  }
}

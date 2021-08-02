import 'package:flutter/material.dart';
import 'package:food_share/screens/auth/login_screen.dart';
import 'package:food_share/viewmodel/bottom_nav.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool isAuth = false;

  Widget buildAuthScreen(){
    return const BottomNav();
  }

  Widget buildUnAuthScreen(){
    return const LoginScreen();
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? buildAuthScreen() : buildUnAuthScreen();
  }
}

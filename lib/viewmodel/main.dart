import 'package:flutter/material.dart';
import 'package:food_share/Viewmodel/bottom_nav.dart';
import 'package:food_share/screens/auth/forgot_password.dart';
import 'package:food_share/services/auth.dart';
import 'package:food_share/viewmodel/wrapper.dart';
import 'package:food_share/screens/auth/login_screen.dart';
import 'package:food_share/screens/auth/sign_up_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      value: null,
      initialData: const [],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FoodyShare',
        theme: ThemeData(
          textTheme:
              GoogleFonts.josefinSansTextTheme(Theme.of(context).textTheme),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const Wrapper(),
          'login': (context) => const LoginScreen(),
          'home': (context) => const BottomNav(),
          'ForgotPassword': (context) => const ForgotPassword(),
          'SignUp': (context) => const SignUpScreen(),
        },
      ),
    );
  }
}

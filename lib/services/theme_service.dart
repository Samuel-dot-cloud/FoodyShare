import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemes {
  static final darkTheme = ThemeData(
      primaryColor: Colors.black,
      primarySwatch: Colors.grey,
      scaffoldBackgroundColor: Colors.grey.shade700,
      iconTheme: const IconThemeData(color: Colors.white, opacity: 0.9),
      colorScheme: const ColorScheme.dark(
        primary: kBlue,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onBackground: Colors.white,
        onError: Colors.white,
      ),
      primaryColorBrightness: Brightness.dark,
      primaryColorLight: Colors.black,
      brightness: Brightness.dark,
      primaryColorDark: Colors.black,
      indicatorColor: Colors.white,
      canvasColor: Colors.black,
      textTheme: GoogleFonts.josefinSansTextTheme(),
      appBarTheme:
          const AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle.dark)
      );

  static final lightTheme = ThemeData(
      primaryColor: Colors.white,
      primarySwatch: Colors.grey,
      iconTheme: const IconThemeData(color: Colors.black, opacity: 0.9),
      scaffoldBackgroundColor: Colors.grey[50],
      colorScheme: const ColorScheme.light(
        primary: kBlue,
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onBackground: Colors.black,
        onError: Colors.black,
      ),
      primaryColorBrightness: Brightness.light,
      brightness: Brightness.light,
      primaryColorDark: Colors.black,
      canvasColor: Colors.white,
      textTheme: GoogleFonts.josefinSansTextTheme(
      ),
      appBarTheme:
          const AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle.light));
}

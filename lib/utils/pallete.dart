import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';

const TextStyle kBodyText = TextStyle(
  fontSize: 22,
  color: Colors.white,
  height: 1.5,
);

buildTextTitleVariation1(String text) {
  return Padding(
    padding: const EdgeInsets.only(
      bottom: 8.0,
    ),
    child: Text(
      text,
      style: GoogleFonts.josefinSans(
        fontSize: 36.0,
        fontWeight: FontWeight.w900,
        color: Colors.black,
      ),
    ),
  );
}

buildTextTitleVariation2(String text, bool opacity) {
  return Padding(
    padding: const EdgeInsets.only(
      bottom: 16.0,
    ),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
        color: opacity ? Colors.grey[400] : Colors.black,
      ),
    ),
  );
}

buildTextSubtitleVariation1(String text) {
  return Padding(
    padding: const EdgeInsets.only(
      bottom: 8.0,
    ),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
        color: Colors.grey[400],
      ),
    ),
  );
}

buildTextSubtitleVariation2(String text) {
  return Padding(
    padding: const EdgeInsets.only(
      bottom: 8.0,
    ),
    child: Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 16.0,
        color: Colors.grey[400],
      ),
    ),
  );
}

buildRecipeTitle(String text) {
  return Padding(
    padding: const EdgeInsets.only(
      bottom: 8.0,
    ),
    child: Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: 22.0,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

buildRecipeSubtitle(String text) {
  return Padding(
    padding: const EdgeInsets.only(
      bottom: 16.0,
    ),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 16.0,
        color: Colors.grey[400],
      ),
    ),
  );
}

buildCalories(String text) {
  return Text(
    text,
    style: const TextStyle(
      fontSize: 16.0,
      color: Colors.black,
      fontWeight: FontWeight.bold,
    ),
  );
}

const Color kWhite = Colors.white;
const Color kBlue = Color(0xFF5663FF);

BoxShadow kBoxShadow = BoxShadow(
  color: Colors.grey.withOpacity(0.2),
  spreadRadius: 2.0,
  blurRadius: 8.0,
  offset: const Offset(
    0,
    0,
  ),
);

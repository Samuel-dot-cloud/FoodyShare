import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IconFont extends StatelessWidget {
  const IconFont(
      {Key? key,
      required this.color,
      required this.size,
      required this.iconName})
      : super(key: key);

  final Color color;
  final double size;
  final String iconName;

  @override
  Widget build(BuildContext context) {
    return Text(
      iconName,
      style: GoogleFonts.robotoMono(
        textStyle: TextStyle(
          color: color,
          fontSize: size,
        ),
      ),
    );
  }
}

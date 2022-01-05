import 'package:flutter/material.dart';

class BackgroundImage extends StatelessWidget {
  final String image;

  const BackgroundImage({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) => const LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.center,
        colors: [
          Colors.black,
          Colors.transparent,
        ],
      ).createShader(bounds),
      blendMode: BlendMode.darken,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(image),
            fit: BoxFit.cover,
            colorFilter: const ColorFilter.mode(
              Colors.black54,
              BlendMode.darken,
            ),
          ),
        ),
      ),
    );
  }
}
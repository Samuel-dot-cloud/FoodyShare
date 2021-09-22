import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_share/config/size_config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transparent_image/transparent_image.dart';

class RecipeHashtagCard extends StatelessWidget {
  const RecipeHashtagCard({Key? key, required this.hashtagDoc }) : super(key: key);

  final DocumentSnapshot hashtagDoc;

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    double size = SizeConfig.defaultSize;
    return Container(
      margin: EdgeInsets.all(size * 2.0),
      height: 150.0,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: hashtagDoc['imageUrl'],
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              height: 120.0,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.transparent,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0.0,
            child: Padding(
              padding: EdgeInsets.all(size * 1.0),
              child: Row(
                children: [
                  SizedBox(
                    width: size * 1.0,
                  ),
                  Text(
                    hashtagDoc['name'],
                    style: GoogleFonts.robotoMono(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: size * 2.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_share/config/size_config.dart';
import 'package:food_share/routes/app_routes.dart';
import 'package:food_share/routes/hashtag_recipes_arguments.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transparent_image/transparent_image.dart';

class RecipeHashtagCard extends StatelessWidget {
  const RecipeHashtagCard(
      {Key? key, required this.hashtagDoc, required this.collectionId})
      : super(key: key);

  final DocumentSnapshot hashtagDoc;
  final String collectionId;

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    double size = SizeConfig.defaultSize;
    return GestureDetector(
      onTap: () {
        final args = HashtagRecipesArguments(
            hashtagName: hashtagDoc['name'],
            collectionDocId: collectionId,
            hashtagId: hashtagDoc['hashtag_id']);
        Navigator.pushNamed(context, AppRoutes.hashtag, arguments: args);
      },
      child: Container(
        margin: EdgeInsets.all(size * 1.0),
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
                      Colors.black.withOpacity(0.9),
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
      ),
    );
  }
}

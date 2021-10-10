import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_share/config/size_config.dart';
import 'package:food_share/routes/app_routes.dart';
import 'package:food_share/routes/recipe_hashtags_arguments.dart';
import 'package:transparent_image/transparent_image.dart';

class RecipeCollectionCard extends StatelessWidget {
  const RecipeCollectionCard({
    Key? key,
    required this.collectionDoc,
  }) : super(key: key);

  final DocumentSnapshot collectionDoc;

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    double size = SizeConfig.defaultSize;
    return GestureDetector(
      onTap: () {
        final args = RecipeHashtagsArguments(
            collectionName: collectionDoc['name'],
            collectionDocId: collectionDoc['collection_id']);
        Navigator.pushNamed(context, AppRoutes.hashtags, arguments: args);
      },
      child: AspectRatio(
        aspectRatio: 1.65,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size * 1.0,
            vertical: size * 1.0,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: _colorFromHex(collectionDoc['color']),
              borderRadius: BorderRadius.circular(size * 1.8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(size * 0.5),
                    child: Column(
                      children: [
                        const Spacer(),
                        Text(
                          collectionDoc['name'],
                          style: TextStyle(
                            fontSize: size * 2.2,
                            color: Colors.white,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: size * 0.1,
                        ),
                        Text(
                          collectionDoc['description'],
                          style: const TextStyle(
                            color: Colors.white54,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        _buildInfoRow(size,
                            data: Icons.person,
                            text: collectionDoc['author_no'].toString() +
                                ' authors'),
                        SizedBox(
                          height: size * 0.1,
                        ),
                        _buildInfoRow(size,
                            data: FontAwesomeIcons.utensils,
                            text: collectionDoc['recipe_no'].toString() +
                                ' recipes'),
                        SizedBox(
                          height: size * 0.1,
                        ),
                        _buildInfoRow(size,
                            data: Icons.grid_3x3_outlined,
                            text: collectionDoc['hashtag_no'].toString() +
                                ' hashtags'),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: size * 0.5,
                ),
                AspectRatio(
                  aspectRatio: 0.71,
                  child:
                  CachedNetworkImage(
                    fit: BoxFit.cover,
                    alignment: Alignment.centerLeft,
                    imageUrl: collectionDoc['imageUrl'],
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) =>
                        CircularProgressIndicator(
                          value: downloadProgress.progress,
                          backgroundColor: Colors.cyanAccent,
                          valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.yellow),
                        ),
                    errorWidget: (context, url, error) =>
                    const Icon(Icons.error),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _colorFromHex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  Row _buildInfoRow(double size,
      {required IconData data, required String text}) {
    return Row(
      children: [
        Icon(
          data,
          color: Colors.white,
        ),
        SizedBox(
          width: size,
        ),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_share/config/size_config.dart';
import 'package:transparent_image/transparent_image.dart';

class RecipeCollectionCard extends StatelessWidget {
  const RecipeCollectionCard(
      {Key? key, required this.collectionDoc,
     })
      : super(key: key);

  final DocumentSnapshot collectionDoc;

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    double size = SizeConfig.defaultSize;
    return AspectRatio(
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
                        height: size * 0.5,
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
                      buildInfoRow(size,
                          data: Icons.person,
                          text: collectionDoc['author_no'].toString() + ' authors'),
                      SizedBox(
                        height: size * 0.3,
                      ),
                      buildInfoRow(size,
                          data: FontAwesomeIcons.utensils,
                          text: collectionDoc['recipe_no'].toString() + ' recipes'),
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
                child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: collectionDoc['imageUrl'],
                  fit: BoxFit.cover,
                  alignment: Alignment.centerLeft,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _colorFromHex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  Row buildInfoRow(double size,
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


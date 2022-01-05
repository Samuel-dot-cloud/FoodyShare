import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_share/config/size_config.dart';
import 'package:food_share/routes/app_routes.dart';
import 'package:food_share/routes/recipe_hashtags_arguments.dart';
import 'package:food_share/services/analytics_service.dart';
import 'package:provider/provider.dart';

import '../../utils/palette.dart';

class RecipeCollectionCard extends StatelessWidget {
  const RecipeCollectionCard({
    Key? key,
    required this.collectionDoc,
  }) : super(key: key);

  final DocumentSnapshot collectionDoc;

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    double _size = SizeConfig.defaultSize;
    return GestureDetector(
      onTap: () {
        Provider.of<AnalyticsService>(context, listen: false)
            .logSelectContent('collection', collectionDoc['name']);
        final args = RecipeHashtagsArguments(
            collectionName: collectionDoc['name'],
            collectionDocId: collectionDoc['collection_id']);
        Navigator.pushNamed(context, AppRoutes.hashtags, arguments: args);
      },
      child: SizedBox(
        height: _size * 16.0,
        child: Stack(
          children: [
            Positioned(
                top: _size * 3.5,
                left: _size * 2.0,
                child: Material(
                  child: Container(
                    height: _size * 18.0,
                    width: _size * 10.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          offset: const Offset(-10.0, 10.0),
                          blurRadius: 20.0,
                          spreadRadius: 4.0,
                        )
                      ],
                    ),
                  ),
                )),
            Positioned(
                top: 0.0,
                left: 20.0,
                child: Card(
                  elevation: 10.0,
                  shadowColor: Colors.grey.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Container(
                    height: _size * 11.0,
                    width: _size * 10.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: CachedNetworkImageProvider(
                            collectionDoc['imageUrl']),
                      ),
                    ),
                  ),
                )),
            Positioned(
                top: _size * 3.5,
                left: _size * 14.0,
                child: SizedBox(
                  height: _size * 15.0,
                  width: _size * 17.0,
                  child: Column(
                    children: [
                      Text(
                        collectionDoc['name'],
                        style: TextStyle(
                          fontSize: _size * 1.8,
                          color: kBlue,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        collectionDoc['description'],
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: _size * 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Divider(
                        color: Colors.black,
                      ),
                      _buildInfoRow(_size,
                          data: FontAwesomeIcons.utensils,
                          text: collectionDoc['recipe_no'].toString() +
                              ' recipes'),
                      SizedBox(
                        height: _size * 0.1,
                      ),
                      _buildInfoRow(_size,
                          data: Icons.grid_3x3_outlined,
                          text: collectionDoc['hashtag_no'].toString() +
                              ' hashtags'),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  // Color _colorFromHex(String hexColor) {
  //   final hexCode = hexColor.replaceAll('#', '');
  //   return Color(int.parse('FF$hexCode', radix: 16));
  // }

  Row _buildInfoRow(double size,
      {required IconData data, required String text}) {
    return Row(
      children: [
        Icon(
          data,
        ),
        SizedBox(
          width: size,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: size * 1.1,
          ),
        ),
      ],
    );
  }
}

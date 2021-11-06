import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_share/services/firebase_operations.dart';
import 'package:food_share/utils/number_formatter.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class ListFlexibleAppBar extends StatelessWidget {
  const ListFlexibleAppBar(
      {Key? key,
      required this.listName,
      required this.listDescription,
      required this.timestamp,
      required this.recipeCount})
      : super(key: key);

  final String listName;
  final String listDescription;
  final Timestamp timestamp;
  final String recipeCount;

  final double appBarHeight = 66.0;

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Container(
      padding: EdgeInsets.only(top: statusBarHeight),
      height: statusBarHeight + appBarHeight,
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 5.0,
              horizontal: 5.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  listName,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "\"" + listDescription + "\"",
                  maxLines: 3,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.robotoMono(
                    textStyle: TextStyle(
                      fontSize: 15.0,
                      color: Colors.grey.shade200,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                ListTile(
                  leading: CircleAvatar(
                    radius: 16.5,
                    backgroundColor: kBlue,
                    backgroundImage: CachedNetworkImageProvider(
                        Provider.of<FirebaseOperations>(context, listen: true)
                            .getUserImage),
                  ),
                  title: Text(
                    Provider.of<FirebaseOperations>(context, listen: false)
                        .getDisplayName,
                    style: const TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    timeago.format(
                      timestamp.toDate(),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(
                    NumberFormatter.formatter(recipeCount) + ' recipe(s)',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      )),
      decoration: BoxDecoration(
        color: Colors.grey[500],
      ),
    );
  }
}

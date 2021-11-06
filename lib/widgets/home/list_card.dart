import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_share/routes/app_routes.dart';
import 'package:food_share/routes/list_recipes_arguments.dart';
import 'package:food_share/services/firebase_operations.dart';
import 'package:food_share/utils/loading_animation.dart';
import 'package:food_share/utils/number_formatter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class BookmarkListCard extends StatelessWidget {
  const BookmarkListCard({
    Key? key,
    required this.favoriteDoc,
  }) : super(key: key);

  final DocumentSnapshot favoriteDoc;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    CollectionReference bookmarkedRecipesRef = FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<FirebaseOperations>(context, listen: false).getUserId)
        .collection('favorites')
        .doc(favoriteDoc['id'])
        .collection('bookmarked');
    return GestureDetector(
      onTap: () {
        final args = ListRecipesArguments(listDoc: favoriteDoc);
        Navigator.pushNamed(context, AppRoutes.listRecipes, arguments: args);
      },
      child: Container(
        height: 150.0,
        width: size.width * 70,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          color: Colors.grey[200],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildListInfoPadding(
                favoriteDoc['name'], favoriteDoc['recipe_count'].toString()),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: bookmarkedRecipesRef
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Error');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return loadingAnimation('Loading images...');
                  }
                  if (snapshot.hasData) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        for (var i = 0;
                            i < snapshot.data!.docs.length && i < 3;
                            i++)
                          buildListImageSizedBox(
                              size,
                              snapshot.data!.docs.isNotEmpty
                                  ? snapshot.data!.docs[i]['postId']
                                  : 'null'),
                      ],
                    );
                  }
                  return const Text('Error ...');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding buildListInfoPadding(String listName, String recipeCount) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, top: 10.0),
      child: Column(
        children: [
          Text(
            listName,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Text(
            NumberFormatter.formatter(recipeCount) + ' recipe(s)',
            style: const TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.normal,
            ),
          ),
          const SizedBox(
            height: 25.0,
          ),
        ],
      ),
    );
  }

  StreamBuilder buildListImageSizedBox(Size size, String postID) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('recipes')
          .doc(postID)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: SizedBox(
              height: 80.0,
              width: size.width * 0.3,
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                alignment: Alignment.centerLeft,
                imageUrl: snapshot.data!['mediaUrl'],
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    CircularProgressIndicator(
                  value: downloadProgress.progress,
                  backgroundColor: Colors.cyanAccent,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Colors.yellow),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          );
        }
      },
    );
  }
}

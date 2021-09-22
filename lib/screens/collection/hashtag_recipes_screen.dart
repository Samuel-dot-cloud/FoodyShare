import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:food_share/routes/hashtag_recipes_arguments.dart';
import 'package:food_share/utils/loading_animation.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:food_share/widgets/collections/recipe_post_image.dart';

CollectionReference collectionsRef =
    FirebaseFirestore.instance.collection('collections');

class HashtagRecipesScreen extends StatelessWidget {
  const HashtagRecipesScreen({Key? key, required this.arguments})
      : super(key: key);

  final HashtagRecipesArguments arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          arguments.hashtagName,
          style: kBodyText.copyWith(
            color: Colors.black,
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: collectionsRef
            .doc(arguments.collectionDocId)
            .collection('hashtags')
            .doc(arguments.hashtagId)
            .collection('recipes')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Error');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return loadingAnimation('Loading recipes...');
          }
          if (snapshot.hasData) {
            return StaggeredGridView.countBuilder(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 12,
              staggeredTileBuilder: (int index) {
                return StaggeredTile.count(
                    1, index.isEven ? 1.2 : 1.8);
              },
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) =>
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 12.0,
                    ),
                    child: RecipePostImage(
                        recipeDoc: snapshot.data!.docs[index]),
                  ),
            );
          }
          return const Text('Loading ...');
        },
      ),
    );
  }
}

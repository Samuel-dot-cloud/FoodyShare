import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_share/services/firebase_operations.dart';
import 'package:food_share/viewmodel/loading_animation.dart';
import 'package:food_share/widgets/favorite_post_image.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

CollectionReference usersRef = FirebaseFirestore.instance.collection('users');

class FavoriteRecipes extends StatefulWidget {
  const FavoriteRecipes({Key? key}) : super(key: key);

  @override
  State<FavoriteRecipes> createState() => _FavoriteRecipesState();
}

class _FavoriteRecipesState extends State<FavoriteRecipes> {
  @override
  Widget build(BuildContext context) {
    final String currentUserId =
        Provider.of<FirebaseOperations>(context, listen: false).getUserId;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            StreamBuilder<QuerySnapshot>(
              stream: usersRef
                  .doc(Provider.of<FirebaseOperations>(context, listen: false)
                      .getUserId)
                  .collection('favorites')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('Error');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return loadingAnimation('Loading recipe card...');
                }
                if (snapshot.hasData) {
                  return snapshot.data!.docs.isNotEmpty
                      ? StaggeredGridView.countBuilder(
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
                            child: FavoritePostImage(
                                recipeDoc: snapshot.data!.docs[index]),
                          ),
                        )
                      : _defaultNoFavorites();
                }
                return const Text('Loading ...');
              },
            ),
          ],
        ),
      ),
    );
  }

  Center _defaultNoFavorites() {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.60,
            width: MediaQuery.of(context).size.width * 0.80,
            child: Lottie.asset('assets/lottie/no-favorite.json'),
          ),
          const SizedBox(
            height: 20.0,
          ),
          const Text(
            'Nothing in favorites...',
            style: TextStyle(
              color: Colors.black,
              fontSize: 23.0,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }
}

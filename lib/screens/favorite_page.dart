import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_share/services/firebase_operations.dart';
import 'package:food_share/viewmodel/loading_animation.dart';
import 'package:food_share/widgets/recipe_card.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

CollectionReference recipesRef =
    FirebaseFirestore.instance.collection('recipes');

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
              stream:
                  recipesRef
                  .where('favorites.' + currentUserId, isEqualTo: true)
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('Error');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return loadingAnimation('Loading recipe card...');
                }
                if (snapshot.hasData) {
                  return snapshot.data!.docs.isNotEmpty ? ListView.builder(
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) => Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                              vertical: 12.0,
                            ),
                            child: RecipeCard(
                                recipeDoc: snapshot.data!.docs[index]),
                          )) : _defaultNoFavorites();
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
            'No favorites list yet...',
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

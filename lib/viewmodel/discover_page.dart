import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_share/widgets/recipe_card.dart';

import 'loading_animation.dart';

class DiscoverRecipe extends StatefulWidget {
  const DiscoverRecipe({Key? key}) : super(key: key);

  @override
  State<DiscoverRecipe> createState() => _DiscoverRecipeState();
}

class _DiscoverRecipeState extends State<DiscoverRecipe> {
  CollectionReference recipesRef =
      FirebaseFirestore.instance.collection('recipes');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            StreamBuilder<QuerySnapshot>(
              stream:
                  recipesRef.orderBy("timestamp", descending: true).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('Error');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return loadingAnimation('Loading recipe card...');
                }
                if (snapshot.hasData) {
                  return ListView.builder(
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
                          ));
                }
                return const Text('Loading ...');
              },
            ),
          ],
        ),
      ),
    );
  }
}

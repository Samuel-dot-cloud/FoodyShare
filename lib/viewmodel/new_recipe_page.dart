import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_share/screens/recipe_details.dart';
import 'package:food_share/services/firebase_operations.dart';
import 'package:food_share/widgets/recipe_card.dart';
import 'package:provider/provider.dart';

import 'loading_animation.dart';

class NewRecipe extends StatefulWidget {
  const NewRecipe({Key? key}) : super(key: key);

  @override
  State<NewRecipe> createState() => _NewRecipeState();
}

class _NewRecipeState extends State<NewRecipe> {
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
              stream: recipesRef.snapshots(),
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
                    itemBuilder: (BuildContext context, int index) {
                      // Provider.of<FirebaseOperations>(context, listen: false)
                      //     .getRecipeDetails(context, '${snapshot.data!.docs[index]['postId']}');
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 12.0,
                        ),
                        child: GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecipeDetails(
                                  recipeId:
                                      '${snapshot.data!.docs[index]['postId']}'),
                            ),
                          ),
                          child: RecipeCard(
                              recipeId:
                                  '${snapshot.data!.docs[index]['postId']}'),
                        ),
                      );
                    },
                  );
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

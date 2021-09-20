import 'package:flutter/material.dart';
import 'package:food_share/widgets/collections/recipe_collection.dart';

class RecipeCollectionsScreen extends StatelessWidget {
  const RecipeCollectionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: const [
            RecipeCollectionCard(),
          ],
        ),
      ),
    );
  }
}

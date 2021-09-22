import 'package:flutter/material.dart';
import 'package:food_share/widgets/collections/recipe_hashtag_card.dart';

class RecipeHashtagScreen extends StatelessWidget {
  const RecipeHashtagScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: RecipeHashtagCard(),

      ),
    );
  }
}

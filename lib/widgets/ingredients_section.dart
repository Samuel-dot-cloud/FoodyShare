import 'package:flutter/material.dart';
import 'package:food_share/models/recipe_model.dart';

class Ingredients extends StatelessWidget {
  final RecipeModel recipeModel;

  const Ingredients({Key? key, required this.recipeModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text('⚫ ' + recipeModel.ingredients[index]),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return Divider(
                color: Colors.black.withOpacity(0.3),
              );
            },
            itemCount: recipeModel.ingredients.length,
            shrinkWrap: true,
            physics: const ScrollPhysics(),
          ),
        ],
      ),
    );
  }
}

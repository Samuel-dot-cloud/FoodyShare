import 'package:flutter/material.dart';
import 'package:food_share/models/recipe_model.dart';

class PreparationSection extends StatelessWidget {
  final RecipeModel recipeModel;

  const PreparationSection({Key? key, required this.recipeModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              int preparationNo = index + 1;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: RichText(
                  text: TextSpan(
                    text: '$preparationNo. ',
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                    children: [
                      TextSpan(
                        text: recipeModel.preparation[index],
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return Divider(
                color: Colors.black.withOpacity(0.3),
              );
            },
            itemCount: recipeModel.preparation.length,
            shrinkWrap: true,
            physics: const ScrollPhysics(),
          ),
        ],
      ),
    );
  }
}

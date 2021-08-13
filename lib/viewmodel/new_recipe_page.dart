import 'package:flutter/material.dart';
import 'package:food_share/models/recipe_model.dart';
import 'package:food_share/screens/recipe_details.dart';
import 'package:food_share/widgets/recipe_card.dart';

class NewRecipe extends StatelessWidget {
  const NewRecipe({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: SingleChildScrollView(
      //   child: Column(
      //     children: [
      //       const SizedBox(
      //         height: 20,
      //       ),
      //      ListView.builder(
      //        physics: const ScrollPhysics(),
      //        shrinkWrap: true,
      //        itemCount: RecipeModel.demoRecipe.length,
      //        itemBuilder: (BuildContext context, int index) {
      //          return Padding(
      //            padding: const EdgeInsets.symmetric(
      //              horizontal: 12.0,
      //              vertical: 12.0,
      //            ),
      //            child: GestureDetector(
      //              onTap: () => Navigator.push(
      //                  context, MaterialPageRoute(
      //                  builder: (context) => RecipeDetails(
      //                      recipeModel: RecipeModel.demoRecipe[index],
      //                  ),
      //              ),
      //              ),
      //              child: RecipeCard(
      //                  recipeModel: RecipeModel.demoRecipe[index],
      //              ),
      //            ),
      //          );
      //        },
      //
      //       ),
      //     ],
      //   ),
      // ),
      body: Provider.of<DiscoverHelper>(context, listen: false).feedBody(context),
    );
  }
}

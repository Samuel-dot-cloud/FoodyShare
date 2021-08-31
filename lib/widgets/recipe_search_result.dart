import 'package:flutter/material.dart';
import 'package:food_share/models/recipe_model.dart';
import 'package:food_share/screens/recipe_details.dart';
import 'package:timeago/timeago.dart' as timeago;

class RecipeResult extends StatelessWidget {
  const RecipeResult({Key? key, required this.recipeModel}) : super(key: key);

  final RecipeModel recipeModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        color: Colors.white54,
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeDetails(
                      servings: recipeModel.servings,
                      recipeName: recipeModel.title,
                      recipeImage: recipeModel.imgPath,
                      postID: recipeModel.id,
                      description: recipeModel.description,
                      authorUserUID: recipeModel.authorId,
                      cookingTime: recipeModel.cookingTime,
                      ingredients: recipeModel.ingredients,
                      recipeTimestamp: recipeModel.createdAt,
                      preparation: recipeModel.preparation,
                    ),
                  ),
                );
              },
              child: ListTile(
                leading: SizedBox(
                  height: 50.0,
                  width: 50.0,
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(recipeModel.imgPath),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                title: Text(
                  recipeModel.title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  recipeModel.description,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
                trailing: Text(
                  'Posted ' +
                      timeago.format(
                        recipeModel.createdAt.toDate(),
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Divider(
                height: 2.0,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

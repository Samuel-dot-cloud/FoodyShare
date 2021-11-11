import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_share/models/recipe_model.dart';
import 'package:food_share/routes/app_routes.dart';
import 'package:food_share/routes/recipe_details_arguments.dart';
import 'package:food_share/services/analytics_service.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class RecipeResult extends StatelessWidget {
  const RecipeResult({Key? key, required this.recipeDoc}) : super(key: key);

  final DocumentSnapshot recipeDoc;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white54,
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Provider.of<AnalyticsService>(context, listen: false)
                  .logViewSearchResults(recipeDoc['name']);
              final args = RecipeDetailsArguments(
                servings: recipeDoc['servings'],
                recipeName: recipeDoc['name'],
                recipeImage: recipeDoc['mediaUrl'],
                postID: recipeDoc['postId'],
                description: recipeDoc['description'],
                authorUserUID: recipeDoc['authorId'],
                cookingTime: recipeDoc['cookingTime'],
                ingredients: recipeDoc['ingredients'],
                recipeTimestamp: recipeDoc['timestamp'],
                preparation: recipeDoc['preparation'],
              );
              Navigator.pushNamed(
                context,
                AppRoutes.recipeDetails,
                arguments: args,
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
                          image:
                              CachedNetworkImageProvider(recipeDoc['mediaUrl']),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              title: Text(
                recipeDoc['name'],
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                recipeDoc['description'],
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
              trailing: Text(
                'Posted ' +
                    timeago.format(
                      recipeDoc['timestamp'].toDate(),
                    ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Divider(
            height: 2.0,
            color: Colors.grey[500],
          ),
        ],
      ),
    );
  }
}

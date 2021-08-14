import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_share/services/firebase_operations.dart';
import 'package:provider/provider.dart';

class RecipeCard extends StatefulWidget {
  const RecipeCard({Key? key, required this.recipeId}) : super(key: key);

  // final RecipeModel recipeModel;
  final String recipeId;

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  bool saved = false;
  bool liked = false;

  @override
  Widget build(BuildContext context) {
    Provider.of<FirebaseOperations>(context, listen: true)
        .getRecipeDetails(context, widget.recipeId);
    return Column(
      children: [
        Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24.0),
                child: Hero(
                  tag: Provider.of<FirebaseOperations>(context, listen: false)
                      .getMediaUrl,
                  child: Image(
                    height: 320.0,
                    width: 320.0,
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        Provider.of<FirebaseOperations>(context, listen: false)
                            .getMediaUrl),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 20.0,
              right: 40.0,
              child: InkWell(
                onTap: () {
                  setState(() {
                    saved = !saved;
                  });
                },
                child: FaIcon(
                  !saved
                      ? FontAwesomeIcons.bookmark
                      : FontAwesomeIcons.solidBookmark,
                  color: Colors.white,
                  size: 28.0,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Provider.of<FirebaseOperations>(context, listen: false)
                          .getRecipeTitle,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      Provider.of<FirebaseOperations>(context, listen: false)
                          .getAuthorId,
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 2,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 20.0,
                    ),
                    const Icon(
                      Icons.timer,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      Provider.of<FirebaseOperations>(context, listen: false)
                              .getRecipeCookingTime +
                          '\'',
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        setState(() {
                          liked = !liked;
                        });
                      },
                      child: FaIcon(
                        FontAwesomeIcons.gratipay,
                        color: liked ? Colors.red : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_share/models/recipe_model.dart';

class RecipeCard extends StatefulWidget {
  const RecipeCard({Key? key, required this.recipeModel}) : super(key: key);
  final RecipeModel recipeModel;

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  bool saved = false;
  bool liked = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24.0),
                child: Hero(
                  tag: widget.recipeModel.imgPath,
                  child: Image(
                    height: 320.0,
                    width: 320.0,
                    fit: BoxFit.cover,
                    image: AssetImage(widget.recipeModel.imgPath),
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
                      widget.recipeModel.title,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      widget.recipeModel.writer,
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
                      widget.recipeModel.cookingTime.toString() + '\'',
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

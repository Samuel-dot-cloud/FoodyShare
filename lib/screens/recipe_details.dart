import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_share/services/firebase_operations.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';


class RecipeDetails extends StatefulWidget {
  final String recipeId;

  const RecipeDetails({Key? key, required this.recipeId}) : super(key: key);

  @override
  State<RecipeDetails> createState() => _RecipeDetailsState();
}

class _RecipeDetailsState extends State<RecipeDetails> {


  @override
  Widget build(BuildContext context) {
    Provider.of<FirebaseOperations>(context, listen: true)
        .getRecipeDetails(context, widget.recipeId);
    Size size = MediaQuery.of(context).size;
    final _textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SlidingUpPanel(
        minHeight: (size.height / 2),
        maxHeight: (size.height / 1.2),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
        parallaxEnabled: true,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Hero(
                  tag: Provider.of<FirebaseOperations>(context, listen: false)
                      .getMediaUrl,
                  child: Image(
                    height: (size.height / 2) + 50,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        Provider.of<FirebaseOperations>(context, listen: false)
                            .getMediaUrl),
                  ),
                ),
              ),
              const Positioned(
                top: 40.0,
                right: 40.0,
                child: FaIcon(
                  FontAwesomeIcons.bookmark,
                  color: Colors.white,
                  size: 32.0,
                ),
              ),
              Positioned(
                top: 40.0,
                left: 20.0,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 32.0,
                  ),
                ),
              ),
            ],
          ),
        ),
        panel: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 5.0,
                  width: 40.0,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              Text(
                Provider.of<FirebaseOperations>(context, listen: false)
                    .getRecipeTitle,
                style: _textTheme.headline6,
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                Provider.of<FirebaseOperations>(context, listen: false)
                    .getAuthorId,
                style: _textTheme.caption,
              ),
              const SizedBox(
                height: 10.0,
              ),
              Row(
                children: [
                  const FaIcon(
                    FontAwesomeIcons.gratipay,
                    color: Colors.red,
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  const Text('500'),
                  const SizedBox(
                    width: 5.0,
                  ),
                  const Icon(
                    Icons.timer,
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  Text(Provider.of<FirebaseOperations>(context, listen: false)
                          .getRecipeCookingTime +
                      '\''),
                  const SizedBox(
                    width: 20.0,
                  ),
                  Container(
                    color: Colors.black,
                    height: 30.0,
                    width: 2.0,
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Text(Provider.of<FirebaseOperations>(context, listen: false)
                          .getServings +
                      ' servings'),
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              Divider(
                color: Colors.black.withOpacity(0.3),
              ),
              Expanded(
                child: DefaultTabController(
                  length: 3,
                  initialIndex: 0,
                  child: Column(
                    children: [
                      TabBar(
                        tabs: [
                          Tab(
                            text: 'Ingredients'.toUpperCase(),
                          ),
                          Tab(
                            text: 'Preparation'.toUpperCase(),
                          ),
                          Tab(
                            text: 'Reviews'.toUpperCase(),
                          ),
                        ],
                        labelColor: Colors.black,
                        indicator: DotIndicator(
                          color: Colors.red,
                          distanceFromCenter: 16.0,
                          radius: 3,
                          paintingStyle: PaintingStyle.fill,
                        ),
                        unselectedLabelColor: Colors.black.withOpacity(0.3),
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12.0,
                        ),
                        labelPadding: const EdgeInsets.symmetric(
                          horizontal: 2.0,
                        ),
                      ),
                      Divider(
                        color: Colors.black.withOpacity(0.3),
                      ),
                      const Expanded(
                        child: TabBarView(
                          children: [
                            SizedBox(
                              child: Text('Ingredients'),
                            ),
                            SizedBox(
                              child: Text('Preparation'),
                            ),
                            // Ingredients(recipeModel: recipeModel),
                            // PreparationSection(recipeModel: recipeModel),
                            SizedBox(
                              child: Text('Review'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

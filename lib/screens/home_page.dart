import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_share/Viewmodel/new_recipe_page.dart';
import 'package:food_share/screens/search_page.dart';
import 'package:food_share/screens/user_profile.dart';
import 'package:food_share/services/recipe_notifier.dart';
import 'package:provider/provider.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    RecipeNotifier recipeNotifier = Provider.of<RecipeNotifier>(context);
    return Scaffold(
      body: SafeArea(
          child: DefaultTabController(
              length: 3,
              initialIndex: 0,
              child: Column(
                children: [
                  const SizedBox(
                    height: 40.0,
                  ),
                  TabBar(
                    isScrollable: true,
                      tabs: [
                    Tab(
                      text: 'New Recipes'.toUpperCase(),
                    ),
                    Tab(
                      text: 'Favourites'.toUpperCase(),
                    ),
                    Tab(
                      text: 'Categories'.toUpperCase(),
                    ),
                  ],
                    labelColor: Colors.black,
                    indicator: DotIndicator(
                      color: Colors.black,
                      distanceFromCenter: 16.0,
                      radius: 3.0,
                      paintingStyle: PaintingStyle.fill,
                    ),
                    unselectedLabelColor: Colors.black.withOpacity(0.3),
                    labelPadding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                        children: [
                          const NewRecipe(),
                          Container(
                            child: Center(
                              child: Text('Favourites'),
                            ),
                          ),
                          Container(
                            child: Center(
                              child: Text('Categories'),
                            ),
                          ),
                        ],
                    ),
                  ),
                ],
              ),
          ),
      ),
    );
  }
}

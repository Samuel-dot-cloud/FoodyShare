import 'package:flutter/material.dart';
import 'package:food_share/screens/favorite_page.dart';
import 'package:food_share/viewmodel/discover_page.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
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
                    text: 'Discover'.toUpperCase(),
                  ),
                  Tab(
                    text: 'Favorites'.toUpperCase(),
                  ),
                  // Tab(
                  //   text: 'Favorites'.toUpperCase(),
                  // ),
                ],
                labelColor: Colors.white,
                indicator: RectangularIndicator(
                  color: Colors.black,
                  paintingStyle: PaintingStyle.fill,
                  topLeftRadius: 100.0,
                  topRightRadius: 100.0,
                  bottomLeftRadius: 100.0,
                  bottomRightRadius: 100.0,
                  verticalPadding: 2.0,
                ),
                unselectedLabelColor: Colors.black.withOpacity(0.5),
                labelPadding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                ),
              ),
              const Expanded(
                child: TabBarView(
                  children: [
                    DiscoverRecipe(),
                    FavoriteRecipes(),
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

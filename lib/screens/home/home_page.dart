import 'package:flutter/material.dart';
import 'package:food_share/screens/home/favorite_page.dart';
import 'package:food_share/utils/constants.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:food_share/screens/home/discover_page.dart';
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          Constants.appName,
          style: kBodyText.copyWith(
            color: Colors.black,
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 16.0,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.category_outlined,
                color: Colors.black,
              ),
              onPressed: () {
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          initialIndex: 0,
          child: Column(
            children: [
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

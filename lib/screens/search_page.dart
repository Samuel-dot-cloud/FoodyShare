import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_share/models/recipe_model.dart';
import 'package:food_share/models/user_model.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:food_share/viewmodel/loading_animation.dart';
import 'package:lottie/lottie.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<bool> optionSelected = [true, false, false];
  bool _searchState = false;
  final usersRef = FirebaseFirestore.instance.collection('users');
  Future<QuerySnapshot>? searchResultsFuture;

  handlesearch(String query) {
    Future<QuerySnapshot> users = usersRef
        .where('displayName', isGreaterThanOrEqualTo: query)
        .get();
    setState(() {
      searchResultsFuture = users;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        elevation: 0.0,
        leading: const Icon(
          Icons.sort,
          color: Colors.black,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 16.0,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.search,
                color: Colors.black,
              ),
              onPressed: () {
                setState(() {
                  _searchState = !_searchState;
                });
              },
            ),
          ),
        ],
        title: Visibility(
          visible: _searchState,
          child: TextFormField(
            decoration: InputDecoration(
              hintText: 'Search here...',
              filled: true,
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {},
              ),
            ),
            onFieldSubmitted: handlesearch,
          ),
        ),
      ),
      body: !_searchState
          ? SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildTextTitleVariation1('Explore section'),
                        buildTextSubtitleVariation1(
                            'A huge selection of tasty and delicious food recipes.'),
                        const SizedBox(
                          height: 32.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // option(
                            //   text: 'Vegetables',
                            //   image: 'assets/icons/salad.png',
                            //   index: 0,
                            // ),
                            // const SizedBox(
                            //   width: 8.0,
                            // ),
                            option(
                              text: 'Meats',
                              image: 'assets/icons/steak.png',
                              index: 0,
                            ),
                            // const SizedBox(
                            //   width: 8.0,
                            // ),
                            option(
                              text: 'Sweets',
                              image: 'assets/icons/candies.png',
                              index: 1,
                            ),
                            // const SizedBox(
                            //   width: 8.0,
                            // ),
                            option(
                              text: 'Cakes',
                              image: 'assets/icons/cake.png',
                              index: 2,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 24.0,
                  ),
                  SizedBox(
                    height: 350.0,
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      children: buildRecipes(),
                    ),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                    ),
                    child: Row(
                      children: [
                        buildTextTitleVariation2('Popular', false),
                        const SizedBox(
                          width: 8.0,
                        ),
                        buildTextTitleVariation2('Food', true),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 190.0,
                    child: PageView(
                      physics: const BouncingScrollPhysics(),
                      children: buildPopulars(),
                    ),
                  ),
                ],
              ),
            )
          : searchState(),
    );
  }

  Widget option(
      {required String text, required String image, required int index}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          optionSelected[index] = !optionSelected[index];
        });
      },
      child: Container(
        height: 40.0,
        decoration: BoxDecoration(
          color: optionSelected[index] ? kBlue : Colors.white,
          borderRadius: const BorderRadius.all(
            Radius.circular(
              20.0,
            ),
          ),
          boxShadow: [kBoxShadow],
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
        ),
        child: Row(
          children: [
            SizedBox(
              height: 32.0,
              width: 32.0,
              child: Image.asset(
                image,
              ),
            ),
            const SizedBox(
              width: 8.0,
            ),
            Text(
              text,
              style: TextStyle(
                color: optionSelected[index] ? Colors.white : Colors.black,
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildRecipes() {
    List<Widget> list = [];
    for (var i = 0; i < RecipeModel.demoRecipe.length; i++) {
      list.add(buildRecipe(RecipeModel.demoRecipe[i], i));
    }
    return list;
  }

  Widget buildRecipe(RecipeModel recipe, int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(
          Radius.circular(
            20.0,
          ),
        ),
        boxShadow: [kBoxShadow],
      ),
      margin: EdgeInsets.only(
        right: 16.0,
        left: index == 0 ? 16.0 : 0,
        bottom: 16.0,
        top: 8.0,
      ),
      padding: const EdgeInsets.all(16.0),
      width: 220.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Hero(
              tag: recipe.imgPath,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(recipe.imgPath),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          buildRecipeTitle(recipe.title),
          buildTextSubtitleVariation2(recipe.description),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildCalories(recipe.servings.toString() + ' servings'),
              const Icon(
                FontAwesomeIcons.gratipay,
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> buildPopulars() {
    List<Widget> list = [];
    for (var i = 0; i < RecipeModel.demoRecipe.length; i++) {
      list.add(buildPopular(RecipeModel.demoRecipe[i]));
    }
    return list;
  }

  searchState() {
    return searchResultsFuture == null ? Center(
      child: ListView(
        shrinkWrap: true,
        children: [
          Lottie.asset(
            'assets/lottie/chef.json',
            height: 300.0,
            width: 300.0,
          ),
          const Text(
            'Search for all things recipes!!!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w600,
              fontSize: 25.0,
            ),
          ),
        ],
      ),
    ) : buildSearchResults();
  }

  buildSearchResults(){
    return FutureBuilder(
      future: searchResultsFuture,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if(!snapshot.hasData){
          return loadingAnimation();
        }
        List<Text> searchResults = [];
        snapshot.data.documents.forEach((doc) {
          CustomUser customUser = CustomUser.fromDocument(doc);
          searchResults.add(Text(customUser.username));
        });
        return ListView(
            children: searchResults,
        );
      });
  }

}

Widget buildPopular(RecipeModel recipe) {
  return Container(
    margin: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: const BorderRadius.all(
        Radius.circular(20.0),
      ),
      boxShadow: [kBoxShadow],
    ),
    child: Row(
      children: [
        Container(
          height: 160.0,
          width: 160.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(recipe.imgPath),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildRecipeTitle(recipe.title),
                buildRecipeSubtitle(recipe.description),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildCalories(recipe.servings.toString() + ' servings'),
                    const Icon(
                      FontAwesomeIcons.gratipay,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

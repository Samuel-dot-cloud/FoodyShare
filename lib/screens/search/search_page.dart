import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_share/config/size_config.dart';
import 'package:food_share/models/recipe_model.dart';
import 'package:food_share/models/user_model.dart';
import 'package:food_share/utils/loading_animation.dart';
import 'package:food_share/widgets/search/recipe_search_result.dart';
import 'package:food_share/widgets/search/user_result.dart';
import 'package:lottie/lottie.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var usersRef = FirebaseFirestore.instance.collection('users');
  var recipesRef = FirebaseFirestore.instance.collection('recipes');
  Future<QuerySnapshot>? searchResultsFuture;

  TextEditingController searchController = TextEditingController();

  bool searchUsers = true;

  handleUserSearch(String query) {
    Future<QuerySnapshot> users = usersRef
        .where('username', isGreaterThanOrEqualTo: query.trim())
        .where('username', isLessThan: query.trim() + 'z')
        .get();
    setState(() {
      searchResultsFuture = users;
    });
  }

  handleRecipeSearch(String query) {
    Future<QuerySnapshot> recipes = recipesRef
        .where('name', isGreaterThanOrEqualTo: query.trim())
        .where('name', isLessThan: query.trim() + 'z')
        .get();
    setState(() {
      searchResultsFuture = recipes;
    });
  }

  clearSearch() {
    searchController.clear();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        elevation: 0.0,
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
                _showSearchSelectionBottomSheet(context);
              },
            ),
          ),
        ],
        title: TextFormField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: searchUsers ? 'Search users...' : 'Search recipes...',
            filled: true,
            prefixIcon: Padding(
              padding: const EdgeInsets.only(bottom: 8.0, left: 29.5),
              child: Icon(
                searchUsers ? Icons.alternate_email : FontAwesomeIcons.utensils,
                color: Colors.black,
                size: 17.0,
              ),
            ),
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: clearSearch,
            ),
          ),
          onChanged: searchUsers ? handleUserSearch : handleRecipeSearch,
          inputFormatters: [
            FilteringTextInputFormatter.deny(RegExp("[@]")),
          ],
        ),
      ),
      body: searchState(),
    );
  }

  searchState() {
    return searchResultsFuture == null || searchController.text.isEmpty
        ? Center(
            child: ListView(
              shrinkWrap: true,
              children: [
                Lottie.asset(
                  'assets/lottie/chef.json',
                  height: MediaQuery.of(context).size.height * 0.60,
                  width: MediaQuery.of(context).size.width * 0.80,
                ),
                Text(
                  'Search for all things recipes!!!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: SizeConfig.defaultSize * 2.3,
                  ),
                ),
              ],
            ),
          )
        : buildSearchResults();
  }

  buildSearchResults() {
    return searchUsers
        ? FutureBuilder(
            future: searchResultsFuture,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return loadingAnimation('Loading users...');
              } else if (snapshot.data?.docs.isEmpty) {
                return _nothingFound(
                    'No users found matching the username provided...');
              } else {
                List<UserResult> searchResults = [];
                snapshot.data?.docs.forEach((doc) {
                  CustomUser customUser = CustomUser.fromDocument(doc);
                  UserResult searchResult = UserResult(customUser: customUser);
                  searchResults.add(searchResult);
                });
                return ListView(
                  children: searchResults,
                );
              }
            })
        : FutureBuilder(
            future: searchResultsFuture,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return loadingAnimation('Loading recipes...');
              } else if (snapshot.data?.docs.isEmpty) {
                return _nothingFound('No recipes found yet..');
              } else {
                List<RecipeResult> searchResults = [];
                snapshot.data?.docs.forEach((doc) {
                  RecipeModel recipeModel = RecipeModel.fromDocument(doc);
                  RecipeResult searchResult =
                      RecipeResult(recipeModel: recipeModel);
                  searchResults.add(searchResult);
                });
                return ListView(
                  children: searchResults,
                );
              }
            });
  }

  _showSearchSelectionBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Search',
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Divider(
                      height: 2.0,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      setState(() {
                        searchUsers = true;
                      });
                      Navigator.pop(context);
                    },
                    leading: const Icon(
                      Icons.alternate_email,
                      color: Colors.black,
                    ),
                    title: const Text(
                      'Search for users',
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 2.0,
                  ),
                  ListTile(
                    onTap: () {
                      setState(() {
                        searchUsers = false;
                      });
                      Navigator.pop(context);
                    },
                    leading: const FaIcon(
                      FontAwesomeIcons.utensils,
                      color: Colors.black,
                      size: 17.0,
                    ),
                    title: const Text(
                      'Search for recipes',
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  _nothingFound(String text) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            SizedBox(
              height: SizeConfig.defaultSize * 40,
              width: SizeConfig.defaultSize * 80,
              child: Lottie.asset('assets/lottie/no-result-found.json'),
            ),
            SizedBox(
              height: SizeConfig.defaultSize,
            ),
            Text(
              text,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: SizeConfig.defaultSize * 2.4,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_share/models/recipe_model.dart';
import 'package:food_share/models/user_model.dart';
import 'package:food_share/viewmodel/loading_animation.dart';
import 'package:food_share/widgets/recipe_search_result.dart';
import 'package:food_share/widgets/user_result.dart';
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
            prefixIcon: Icon(
              searchUsers ? Icons.alternate_email : FontAwesomeIcons.utensils,
              color: Colors.black,
              size: 17.0,
            ),
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: clearSearch,
            ),
          ),
          onChanged: searchUsers ? handleUserSearch : handleRecipeSearch,
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
                const Text(
                  'Search for all things recipes!!!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 23.0,
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
}

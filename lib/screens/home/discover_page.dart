import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:food_share/widgets/recipe/recipe_card.dart';
import 'package:food_share/widgets/refresh_widget.dart';

import '../../utils/loading_animation.dart';

class DiscoverRecipe extends StatefulWidget {
  const DiscoverRecipe({Key? key}) : super(key: key);

  @override
  State<DiscoverRecipe> createState() => _DiscoverRecipeState();
}

class _DiscoverRecipeState extends State<DiscoverRecipe>
    with AutomaticKeepAliveClientMixin<DiscoverRecipe> {
  CollectionReference recipesRef =
      FirebaseFirestore.instance.collection('recipes');

  final StreamController<List<DocumentSnapshot>> _recipeController =
      StreamController<List<DocumentSnapshot>>.broadcast();

  final List<List<DocumentSnapshot>> _allPagedResults = [<DocumentSnapshot>[]];

  static const int recipeLimit = 10;
  DocumentSnapshot? _lastDocument;
  bool _hasMoreData = true;

  getRecipes() async {
    final CollectionReference _recipeCollectionReference = recipesRef;
    var pageRecipeQuery = _recipeCollectionReference
        .orderBy('timestamp', descending: true)
        .limit(recipeLimit);

    if (_lastDocument != null) {
      pageRecipeQuery = pageRecipeQuery.startAfterDocument(_lastDocument!);
    }

    if (!_hasMoreData) {
      Fluttertoast.showToast(
          msg: 'No more recipes to display',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: kBlue,
          textColor: Colors.white,
          fontSize: 16.0);
    }

    var currentRequestIndex = _allPagedResults.length;
    pageRecipeQuery.snapshots().listen(
      (snapshot) {
        if (snapshot.docs.isNotEmpty) {
          var generalRecipes = snapshot.docs.toList();

          var pageExists = currentRequestIndex < _allPagedResults.length;

          if (pageExists) {
            _allPagedResults[currentRequestIndex] = generalRecipes;
          } else {
            _allPagedResults.add(generalRecipes);
          }

          var allRecipes = _allPagedResults.fold<List<DocumentSnapshot>>(
              <DocumentSnapshot>[],
              (initialValue, pageItems) => initialValue..addAll(pageItems));

          _recipeController.add(allRecipes);

          if (currentRequestIndex == _allPagedResults.length - 1) {
            _lastDocument = snapshot.docs.last;
          }

          _hasMoreData = generalRecipes.length == recipeLimit;
        }
      },
    );
  }

  Stream<List<DocumentSnapshot>> listenToRecipesRealTime() {
    getRecipes();
    return _recipeController.stream;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: RefreshWidget(
        onRefresh: () async {
          _allPagedResults.clear();
          _lastDocument = null;
          await getRecipes();
        },
        child: SingleChildScrollView(
          child: StreamBuilder<List<DocumentSnapshot>>(
            stream: listenToRecipesRealTime(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Error');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return loadingAnimation('Loading recipes...');
              }
              if (snapshot.hasData) {
                return Column(
                  children: [
                    ListView.builder(
                        physics: const ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) =>
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 12.0,
                              ),
                              child:
                                  RecipeCard(recipeDoc: snapshot.data![index]),
                            )),
                    const SizedBox(
                      height: 10.0,
                    ),
                    OutlinedButton(
                      onPressed: () {
                        getRecipes();
                      },
                      child: const Text(
                        'LOAD MORE',
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            side: const BorderSide(color: kBlue),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
              return const Text('Loading ...');
            },
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_share/helpers/recipe_detail_helper.dart';
import 'package:food_share/services/firebase_operations.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:food_share/widgets/home/list_card.dart';
import 'package:food_share/widgets/refresh_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

CollectionReference usersRef = FirebaseFirestore.instance.collection('users');

class FavoriteRecipes extends StatelessWidget {
  const FavoriteRecipes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final StreamController<List<DocumentSnapshot>> _favoriteController =
        StreamController<List<DocumentSnapshot>>.broadcast();

    final List<List<DocumentSnapshot>> _allPagedResults = [
      <DocumentSnapshot>[]
    ];

    const int favoriteRecipeLimit = 5;
    DocumentSnapshot? _lastDocument;
    bool _hasMoreData = true;

    getFavorites() async {
      final CollectionReference _favoriteCollectionReference = usersRef
          .doc(
              Provider.of<FirebaseOperations>(context, listen: false).getUserId)
          .collection('favorites');
      var pageRecipeQuery = _favoriteCollectionReference
          .orderBy('timestamp', descending: true)
          .limit(favoriteRecipeLimit);

      if (_lastDocument != null) {
        pageRecipeQuery = pageRecipeQuery.startAfterDocument(_lastDocument!);
      }

      if (!_hasMoreData) {
        Fluttertoast.showToast(
            msg: 'No more favorites to display',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.blueAccent,
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

            _favoriteController.add(allRecipes);

            if (currentRequestIndex == _allPagedResults.length - 1) {
              _lastDocument = snapshot.docs.last;
            }

            _hasMoreData = generalRecipes.length == favoriteRecipeLimit;
          }
        },
      );
    }

    Stream<List<DocumentSnapshot>> listenToFavoritesRealTime() {
      getFavorites();
      return _favoriteController.stream;
    }

    Center _defaultNoFavorites() {
      return Center(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.60,
              width: MediaQuery.of(context).size.width * 0.80,
              child: Lottie.asset('assets/lottie/no-favorite.json'),
            ),
            const SizedBox(
              height: 20.0,
            ),
            const Text(
              'Nothing in favorites...',
              style: TextStyle(
                color: Colors.black,
                fontSize: 23.0,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      );
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        tooltip: 'Create list',
        backgroundColor: kBlue,
        child: const Icon(Icons.create_rounded),
          onPressed: (){
          Provider.of<RecipeDetailHelper>(context, listen: false).createListBottomSheetForm(context);
          }),
      body: RefreshWidget(
        onRefresh: () async {
          _allPagedResults.clear();
          _lastDocument = null;
          await getFavorites();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              StreamBuilder<List<DocumentSnapshot>>(
                stream: listenToFavoritesRealTime(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Error');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _defaultNoFavorites();
                  } else if (snapshot.hasData) {
                    if (snapshot.data!.isNotEmpty) {
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
                                    child: BookmarkListCard(favoriteDoc: snapshot.data![index], ),
                                  )),

                          const SizedBox(
                            height: 10.0,
                          ),
                          OutlinedButton(
                            onPressed: () {
                              getFavorites();
                            },
                            child: const Text(
                              'LOAD MORE',
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  side: const BorderSide(color: kBlue),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      _defaultNoFavorites();
                    }
                  }
                  return const Text('Loading ...');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

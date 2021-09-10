import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_share/services/firebase_operations.dart';
import 'package:food_share/utils/loading_animation.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:food_share/widgets/home/favorite_post_image.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

CollectionReference usersRef = FirebaseFirestore.instance.collection('users');

class FavoriteRecipes extends StatefulWidget {
  const FavoriteRecipes({Key? key}) : super(key: key);

  @override
  State<FavoriteRecipes> createState() => _FavoriteRecipesState();
}

class _FavoriteRecipesState extends State<FavoriteRecipes> {
  final StreamController<List<DocumentSnapshot>> _favoriteController =
      StreamController<List<DocumentSnapshot>>.broadcast();

  final List<List<DocumentSnapshot>> _allPagedResults = [<DocumentSnapshot>[]];

  static const int favoriteRecipeLimit = 5;
  DocumentSnapshot? _lastDocument;
  bool _hasMoreData = true;

  Stream<List<DocumentSnapshot>> listenToFavoritesRealTime() {
    getFavorites();
    return _favoriteController.stream;
  }

  getFavorites() async {
    final CollectionReference _favoriteCollectionReference = usersRef
        .doc(Provider.of<FirebaseOperations>(context, listen: false).getUserId)
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                  return loadingAnimation('Loading favorites...');
                } else if (snapshot.hasData) {
                  if (snapshot.data!.isNotEmpty) {
                    return Column(
                      children: [
                        StaggeredGridView.countBuilder(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 12,
                          staggeredTileBuilder: (int index) {
                            return StaggeredTile.count(
                                1, index.isEven ? 1.2 : 1.8);
                          },
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (BuildContext context, int index) =>
                              Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                              vertical: 12.0,
                            ),
                            child: FavoritePostImage(
                                recipeDoc: snapshot.data![index]),
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        OutlinedButton(
                          onPressed: () {
                            getFavorites();
                          },
                          child: const Text(
                            'SEE MORE',
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
    );
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
}

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:food_share/models/entitlement.dart';
import 'package:food_share/routes/hashtag_recipes_arguments.dart';
import 'package:food_share/services/revenuecat_provider.dart';
import 'package:food_share/utils/palette.dart';
import 'package:food_share/widgets/collections/recipe_post_image.dart';
import 'package:food_share/widgets/refresh_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class HashtagRecipesScreen extends StatefulWidget {
  const HashtagRecipesScreen({Key? key, required this.arguments})
      : super(key: key);

  final HashtagRecipesArguments arguments;

  @override
  State<HashtagRecipesScreen> createState() => _HashtagRecipesScreenState();
}

class _HashtagRecipesScreenState extends State<HashtagRecipesScreen> with AutomaticKeepAliveClientMixin<HashtagRecipesScreen> {
  final CollectionReference _collectionsRef =
      FirebaseFirestore.instance.collection('collections');

  final StreamController<List<DocumentSnapshot>> _hashtagRecipeController =
      StreamController<List<DocumentSnapshot>>.broadcast();

  final List<List<DocumentSnapshot>> _allPagedResults = [<DocumentSnapshot>[]];

  final int _hashtagRecipeLimit = 10;
  DocumentSnapshot? _lastDocument;

  // bool _hasMoreData = true;

  _getHashtagRecipes() async {
    final CollectionReference _hashtagRecipeCollectionReference = _collectionsRef
        .doc(widget.arguments.collectionDocId)
        .collection('hashtags')
        .doc(widget.arguments.hashtagId)
        .collection('recipes');
    var pageHashtagRecipeQuery = _hashtagRecipeCollectionReference
        .orderBy('timestamp', descending: true)
        .limit(_hashtagRecipeLimit);

    if (_lastDocument != null) {
      pageHashtagRecipeQuery =
          pageHashtagRecipeQuery.startAfterDocument(_lastDocument!);
    }

    // if (!_hasMoreData) {
    //   Fluttertoast.showToast(
    //       msg: 'No more recipes to display',
    //       toastLength: Toast.LENGTH_SHORT,
    //       gravity: ToastGravity.BOTTOM,
    //       timeInSecForIosWeb: 1,
    //       backgroundColor: kBlue,
    //       textColor: Colors.white,
    //       fontSize: 16.0);
    // }

    var currentRequestIndex = _allPagedResults.length;
    pageHashtagRecipeQuery.snapshots().listen(
      (snapshot) {
        if (snapshot.docs.isNotEmpty) {
          var generalHashtagRecipes = snapshot.docs.toList();

          var pageExists = currentRequestIndex < _allPagedResults.length;

          if (pageExists) {
            _allPagedResults[currentRequestIndex] = generalHashtagRecipes;
          } else {
            _allPagedResults.add(generalHashtagRecipes);
          }

          var allRecipes = _allPagedResults.fold<List<DocumentSnapshot>>(
              <DocumentSnapshot>[],
              (initialValue, pageItems) => initialValue..addAll(pageItems));

          _hashtagRecipeController.add(allRecipes);

          if (currentRequestIndex == _allPagedResults.length - 1) {
            _lastDocument = snapshot.docs.last;
          }

          // _hasMoreData = generalHashtagRecipes.length == _hashtagRecipeLimit;
        }
      },
    );
  }

  Stream<List<DocumentSnapshot>> listenToHashtagRecipesRealTime() {
    _getHashtagRecipes();
    return _hashtagRecipeController.stream;
  }

  Center _defaultNoRecipes() {
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
            'No recipes here...',
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final _entitlement = Provider.of<RevenueCatProvider>(context, listen: true).entitlement;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.arguments.hashtagName,
          style: kBodyText.copyWith(
            fontSize: 25.0,
            fontWeight: FontWeight.normal,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: RefreshWidget(
          onRefresh: () async {
            _allPagedResults.clear();
            _lastDocument = null;
            await _getHashtagRecipes();
          },
          child: SingleChildScrollView(
            child: StreamBuilder<List<DocumentSnapshot>>(
              stream: listenToHashtagRecipesRealTime(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('Error');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _defaultNoRecipes();
                }
                if (snapshot.hasData) {
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
                          child:
                              RecipePostImage(recipeDoc: snapshot.data![index]),
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Visibility(
                        visible: _entitlement == Entitlement.free ? false : true,
                        child: OutlinedButton(
                          onPressed: () {
                            _getHashtagRecipes();
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
                      ),
                    ],
                  );
                }
                return const Text('Loading ...');
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

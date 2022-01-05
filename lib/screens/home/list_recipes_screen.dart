import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_share/helpers/list_recipes_helper.dart';
import 'package:food_share/routes/app_routes.dart';
import 'package:food_share/routes/list_recipes_arguments.dart';
import 'package:food_share/services/firebase_operations.dart';
import 'package:food_share/utils/palette.dart';
import 'package:food_share/widgets/home/favorite_post_image.dart';
import 'package:food_share/widgets/home/list_flexible_appbar.dart';
import 'package:food_share/widgets/refresh_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class ListRecipesScreen extends StatelessWidget {
  const ListRecipesScreen({Key? key, required this.arguments})
      : super(key: key);

  final ListRecipesArguments arguments;

  @override
  Widget build(BuildContext context) {
    CollectionReference bookmarkedRef = FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<FirebaseOperations>(context, listen: false).getUserId)
        .collection('favorites')
        .doc(arguments.listDoc['id'])
        .collection('bookmarked');

    final StreamController<List<DocumentSnapshot>> _bookmarkedController =
        StreamController<List<DocumentSnapshot>>.broadcast();

    final List<List<DocumentSnapshot>> _allPagedResults = [
      <DocumentSnapshot>[]
    ];

    const int bookmarkedRecipeLimit = 10;
    DocumentSnapshot? _lastDocument;
    // bool _hasMoreData = true;

    getBookmarkedRecipes() async {
      final CollectionReference _bookmarkedCollectionReference = bookmarkedRef;
      var pageBookmarkedQuery = _bookmarkedCollectionReference
          .orderBy('timestamp', descending: true)
          .limit(bookmarkedRecipeLimit);

      if (_lastDocument != null) {
        pageBookmarkedQuery =
            pageBookmarkedQuery.startAfterDocument(_lastDocument!);
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
      pageBookmarkedQuery.snapshots().listen(
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

            _bookmarkedController.add(allRecipes);

            if (currentRequestIndex == _allPagedResults.length - 1) {
              _lastDocument = snapshot.docs.last;
            }

            // _hasMoreData = generalRecipes.length == bookmarkedRecipeLimit;
          }
        },
      );
    }

    Stream<List<DocumentSnapshot>> listenToBookmarkedRecipesRealTime() {
      getBookmarkedRecipes();
      return _bookmarkedController.stream;
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

    Future<void> showDeleteAlertDialog() async {
      return showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) {
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20.0),
                ),
              ),
              title: const Text(
                'Delete list?',
                style: TextStyle(
                  fontSize: 23.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              content: const Text(
                'This is an irreversible action!!',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20.0,
                ),
              ),
              actions: [
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.black,
                    ),
                  ),
                ),
                MaterialButton(
                  color: kBlue,
                  onPressed: () {
                    Provider.of<FirebaseOperations>(context, listen: false)
                        .deleteFavoriteList(
                            Provider.of<FirebaseOperations>(context,
                                    listen: false)
                                .getUserId,
                            arguments.listDoc['id'])
                        .whenComplete(() {
                      Navigator.pop(context);
                      Fluttertoast.showToast(
                          msg: 'List successfully deleted',
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: kBlue,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      Navigator.pushReplacementNamed(
                          context, AppRoutes.bottomNav);
                    });
                  },
                  child: const Text(
                    'Go Ahead',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          });
    }

    return Scaffold(
      body: RefreshWidget(
        onRefresh: () async {
          _allPagedResults.clear();
          _lastDocument = null;
          await getBookmarkedRecipes();
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.grey[500],
              pinned: true,
              centerTitle: true,
              elevation: 0.0,
              expandedHeight: 210.0,
              title: Text(
                arguments.listDoc['name'],
                overflow: TextOverflow.fade,
                style: kBodyText.copyWith(
                  fontSize: 25.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              leading: IconButton(
                tooltip: 'Go back',
                icon: const Icon(
                  Icons.arrow_back_ios,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: [
                PopupMenuButton<int>(
                    tooltip: 'More options',
                    onSelected: (value) {
                      if (value == 1) {
                        Provider.of<ListRecipesHelper>(context, listen: false)
                            .editListBottomSheetForm(
                                context, arguments.listDoc['id']);
                      } else if (value == 2) {
                        showDeleteAlertDialog();
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                          const PopupMenuItem(
                            value: 1,
                            child: Text('Edit list info'),
                          ),
                          const PopupMenuItem(
                            value: 2,
                            child: Text('Delete list'),
                          ),
                        ]
                    )
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: ListFlexibleAppBar(
                  listName: arguments.listDoc['name'],
                  listDescription: arguments.listDoc['description'],
                  timestamp: arguments.listDoc['lastEdited'],
                  recipeCount: arguments.listDoc['recipe_count'].toString(),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: StreamBuilder<List<DocumentSnapshot>>(
                stream: listenToBookmarkedRecipesRealTime(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Error');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _defaultNoFavorites();
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
                          primary: false,
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
                            getBookmarkedRecipes();
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
                  }
                  return const Text('Loading ...');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

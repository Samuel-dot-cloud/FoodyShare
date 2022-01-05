import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_share/routes/app_routes.dart';
import 'package:food_share/services/firebase_operations.dart';
import 'package:food_share/helpers/profile_helper.dart';
import 'package:food_share/utils/palette.dart';
import 'package:food_share/widgets/profile/profile_post_image.dart';
import 'package:food_share/widgets/refresh_widget.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  double hPadding = 40.0;

  ///Recipe grid view pagination logic
  final usersRef = FirebaseFirestore.instance.collection('users');

  final StreamController<List<DocumentSnapshot>> _recipeGridController =
      StreamController<List<DocumentSnapshot>>.broadcast();

  final List<List<DocumentSnapshot>> _allPagedResults = [<DocumentSnapshot>[]];

  static const int recipeGridLimit = 5;
  DocumentSnapshot? _lastDocument;
  bool _hasMoreData = true;

  Stream<List<DocumentSnapshot>> listenToRecipeGridRealTime() {
    getRecipeGrid();
    return _recipeGridController.stream;
  }

  getRecipeGrid() async {
    final CollectionReference _recipeCollectionReference = usersRef
        .doc(Provider.of<FirebaseOperations>(context, listen: false).getUserId)
        .collection('recipes');
    var pageRecipeQuery = _recipeCollectionReference
        .orderBy('timestamp', descending: true)
        .limit(recipeGridLimit);

    if (_lastDocument != null) {
      pageRecipeQuery = pageRecipeQuery.startAfterDocument(_lastDocument!);
    }

    if (!_hasMoreData) {
      Fluttertoast.showToast(
          msg: 'No more recipes to display',
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

          _recipeGridController.add(allRecipes);

          if (currentRequestIndex == _allPagedResults.length - 1) {
            _lastDocument = snapshot.docs.last;
          }

          _hasMoreData = generalRecipes.length == recipeGridLimit;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SlidingUpPanel(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
        minHeight: (size.height / 2.3),
        maxHeight: (size.height / 1.2),
        parallaxEnabled: true,
        color: Theme.of(context).scaffoldBackgroundColor,
        body: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Hero(
                  tag: Provider.of<FirebaseOperations>(context, listen: false)
                      .getUserImage,
                  child: Image(
                    height: (size.height / 2) + 50,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(
                        Provider.of<FirebaseOperations>(context, listen: false)
                            .getUserImage),
                  ),
                ),
              ),
            ],
          ),
        ),
        panel: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: hPadding),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(
                    height: 10.0,
                  ),
                  Provider.of<ProfileHelper>(context, listen: false)
                      .titleSection(
                          Provider.of<FirebaseOperations>(context,
                                  listen: false)
                              .getDisplayName,
                          Provider.of<FirebaseOperations>(context,
                                  listen: false)
                              .getUsername,
                          Provider.of<FirebaseOperations>(context,
                                  listen: false)
                              .getUserBio),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Provider.of<ProfileHelper>(context, listen: false)
                      .infoSection(
                          context,
                          Provider.of<FirebaseOperations>(context,
                                  listen: false)
                              .getUserId),
                  const SizedBox(
                    height: 12.0,
                  ),
                  _actionSection(hPadding: hPadding),
                ],
              ),
            ),

            ///Post Gridview
            Expanded(
              child: RefreshWidget(
                onRefresh: () async {
                  _allPagedResults.clear();
                  _lastDocument = null;
                  await getRecipeGrid();
                },
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      child: Column(
                        children: [
                          StreamBuilder<List<DocumentSnapshot>>(
                            stream: listenToRecipeGridRealTime(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Provider.of<ProfileHelper>(context,
                                        listen: false)
                                    .defaultNoRecipes(context);
                              } else {
                                return Column(
                                  children: [
                                    GridView.builder(
                                      primary: false,
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      itemCount: snapshot.data!.length,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 16.0,
                                      ),
                                      itemBuilder:
                                          (BuildContext context, int index) =>
                                              Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 3.0),
                                        child: ProfilePostImage(
                                          recipeDoc: snapshot.data![index],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    OutlinedButton(
                                      onPressed: () {
                                        getRecipeGrid();
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
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                            side: const BorderSide(color: kBlue),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///Action section
  Container _actionSection({required double hPadding}) {
    return Container(
      alignment: Alignment.center,
      child: SizedBox(
        width: double.infinity,
        child: TextButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.settings);
          },
          child: const Text(
            'SETTINGS',
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            backgroundColor: MaterialStateProperty.all<Color>(kBlue),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
                side: const BorderSide(color: kBlue),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

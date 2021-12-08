import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_share/routes/app_routes.dart';
import 'package:food_share/routes/curate_hashtag_arguments.dart';
import 'package:food_share/routes/recipe_hashtags_arguments.dart';
import 'package:food_share/utils/loading_animation.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:food_share/widgets/collections/recipe_hashtag_card.dart';
import 'package:food_share/widgets/refresh_widget.dart';

class RecipeHashtagCollectionScreen extends StatelessWidget {
  const RecipeHashtagCollectionScreen({Key? key, required this.arguments})
      : super(key: key);

  final RecipeHashtagsArguments arguments;

  @override
  Widget build(BuildContext context) {
    CollectionReference collectionsRef =
        FirebaseFirestore.instance.collection('collections');

    final StreamController<List<DocumentSnapshot>> _hashtagController =
        StreamController<List<DocumentSnapshot>>.broadcast();

    final List<List<DocumentSnapshot>> _allPagedResults = [
      <DocumentSnapshot>[]
    ];

    const int hashtagLimit = 20;
    DocumentSnapshot? _lastDocument;
    bool _hasMoreData = true;

    _getHashtags() async {
      final CollectionReference _hashtagCollectionReference =
          collectionsRef.doc(arguments.collectionDocId).collection('hashtags');
      var pageHashtagQuery = _hashtagCollectionReference
          .orderBy('timestamp', descending: true)
          .limit(hashtagLimit);

      if (_lastDocument != null) {
        pageHashtagQuery = pageHashtagQuery.startAfterDocument(_lastDocument!);
      }

      if (!_hasMoreData) {
        Fluttertoast.showToast(
            msg: 'No more hashtags to display',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: kBlue,
            textColor: Colors.white,
            fontSize: 16.0);
      }

      var currentRequestIndex = _allPagedResults.length;
      pageHashtagQuery.snapshots().listen(
        (snapshot) {
          if (snapshot.docs.isNotEmpty) {
            var generalHashtags = snapshot.docs.toList();

            var pageExists = currentRequestIndex < _allPagedResults.length;

            if (pageExists) {
              _allPagedResults[currentRequestIndex] = generalHashtags;
            } else {
              _allPagedResults.add(generalHashtags);
            }

            var allHashtags = _allPagedResults.fold<List<DocumentSnapshot>>(
                <DocumentSnapshot>[],
                (initialValue, pageItems) => initialValue..addAll(pageItems));

            _hashtagController.add(allHashtags);

            if (currentRequestIndex == _allPagedResults.length - 1) {
              _lastDocument = snapshot.docs.last;
            }

            _hasMoreData = generalHashtags.length == hashtagLimit;
          }
        },
      );
    }

    Stream<List<DocumentSnapshot>> listenToHashtagsRealTime() {
      _getHashtags();
      return _hashtagController.stream;
    }

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
          arguments.collectionName,
          style: kBodyText.copyWith(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        // actions: [
        //   IconButton(
        //     icon: const Icon(
        //       Icons.add_outlined,
        //     ),
        //     onPressed: () {
        //       final args = CurateHashtagArguments(
        //           collectionID: arguments.collectionDocId);
        //       Navigator.pushNamed(context, AppRoutes.curate, arguments: args);
        //     },
        //   ),
        // ],
      ),
      body: SafeArea(
        child: RefreshWidget(
          onRefresh: () async {
            _allPagedResults.clear();
            _lastDocument = null;
            await _getHashtags();
          },
          child: SingleChildScrollView(
            child: StreamBuilder<List<DocumentSnapshot>>(
              stream: listenToHashtagsRealTime(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('Error');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return loadingAnimation('Loading hashtags...');
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
                          child: RecipeHashtagCard(
                            hashtagDoc: snapshot.data![index],
                            collectionId: arguments.collectionDocId,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      OutlinedButton(
                        onPressed: () {
                          _getHashtags();
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
      ),
    );
  }
}

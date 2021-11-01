import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_share/services/firebase_operations.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:food_share/widgets/recipe/labeled_checkbox.dart';
import 'package:food_share/widgets/refresh_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class ListsSelectionView extends StatelessWidget {
  const ListsSelectionView({Key? key})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    CollectionReference favoritesRef = FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<FirebaseOperations>(context, listen: false).getUserId)
        .collection('favorites');
    bool _checkedValue = false;

    final StreamController<List<DocumentSnapshot>> _favoriteListController =
        StreamController<List<DocumentSnapshot>>.broadcast();

    final List<List<DocumentSnapshot>> _allPagedResults = [
      <DocumentSnapshot>[]
    ];

    const int _favoriteLimit = 10;
    DocumentSnapshot? _lastDocument;
    bool _hasMoreData = true;

    _getFavoriteLists() async {
      final CollectionReference _favoriteCollectionReference = favoritesRef;
      var pageRecipeQuery = _favoriteCollectionReference
          .orderBy('timestamp', descending: true)
          .limit(_favoriteLimit);

      if (_lastDocument != null) {
        pageRecipeQuery = pageRecipeQuery.startAfterDocument(_lastDocument!);
      }

      if (!_hasMoreData) {
        Fluttertoast.showToast(
            msg: 'No more lists to display',
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
            var generalLists = snapshot.docs.toList();

            var pageExists = currentRequestIndex < _allPagedResults.length;

            if (pageExists) {
              _allPagedResults[currentRequestIndex] = generalLists;
            } else {
              _allPagedResults.add(generalLists);
            }

            var allLists = _allPagedResults.fold<List<DocumentSnapshot>>(
                <DocumentSnapshot>[],
                (initialValue, pageItems) => initialValue..addAll(pageItems));

            _favoriteListController.add(allLists);

            if (currentRequestIndex == _allPagedResults.length - 1) {
              _lastDocument = snapshot.docs.last;
            }

            _hasMoreData = generalLists.length == _favoriteLimit;
          }
        },
      );
    }

    Stream<List<DocumentSnapshot>> listenToFavoriteListRealTime() {
      _getFavoriteLists();
      return _favoriteListController.stream;
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

    return RefreshWidget(
      onRefresh: () async {
        _allPagedResults.clear();
        _lastDocument = null;
        await _getFavoriteLists();
      },
      child: SingleChildScrollView(
        child: StreamBuilder<List<DocumentSnapshot>>(
            stream: listenToFavoriteListRealTime(),
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
                              LabeledCheckbox(
                                  label: snapshot.data![index]['name'],
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  value: _checkedValue,
                                  onChanged: (bool newValue) {
                                    _checkedValue = newValue;
                                  })),
                      const SizedBox(
                        height: 10.0,
                      ),
                      OutlinedButton(
                        onPressed: () {
                          _getFavoriteLists();
                        },
                        child: const Text(
                          'LOAD MORE',
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w700,
                            color: kBlue,
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
              }
              return const Text('Loading ...');
            }),
      ),
    );
  }
}

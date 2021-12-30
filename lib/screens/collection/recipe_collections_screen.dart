import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_share/utils/loading_animation.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:food_share/widgets/collections/recipe_collection_card.dart';
import 'package:lottie/lottie.dart';

class RecipeCollectionsScreen extends StatelessWidget {
  const RecipeCollectionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference _collectionsRef =
        FirebaseFirestore.instance.collection('collections');

    Center _defaultNoCollections() {
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
              'No collections here...',
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
          'Collections',
          style: kBodyText.copyWith(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: _collectionsRef
                .orderBy('timestamp', descending: true)
                .snapshots().asBroadcastStream(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Error');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return loadingAnimation('Loading collections...');
              }
              if (snapshot.hasData) {
                return ListView.builder(
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) => Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 12.0,
                          ),
                          child: RecipeCollectionCard(
                            collectionDoc: snapshot.data!.docs[index],
                          ),
                        ));
              } else {
                _defaultNoCollections();
              }
              return const Text('Loading ...');
            },
          ),
        ),
      ),
    );
  }
}

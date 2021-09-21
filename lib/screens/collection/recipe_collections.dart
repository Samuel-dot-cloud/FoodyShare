import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_share/utils/loading_animation.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:food_share/widgets/collections/recipe_collection_card.dart';

CollectionReference collectionsRef =
    FirebaseFirestore.instance.collection('collections');

class RecipeCollectionsScreen extends StatelessWidget {
  const RecipeCollectionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Collections',
          style: kBodyText.copyWith(
            color: Colors.black,
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: collectionsRef
                .orderBy('timestamp', descending: true)
                .snapshots(),
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
              }
              return const Text('Loading ...');
            },
          ),
        ),
      ),
    );
  }
}

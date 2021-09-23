import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_share/routes/recipe_hashtags_arguments.dart';
import 'package:food_share/utils/loading_animation.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:food_share/widgets/collections/recipe_hashtag_card.dart';

CollectionReference collectionsRef =
    FirebaseFirestore.instance.collection('collections');

class RecipeHashtagCollectionScreen extends StatelessWidget {
  const RecipeHashtagCollectionScreen({Key? key, required this.arguments})
      : super(key: key);

  final RecipeHashtagsArguments arguments;

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
          arguments.collectionName,
          style: kBodyText.copyWith(
            color: Colors.black,
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: collectionsRef
              .doc(arguments.collectionDocId)
              .collection('hashtags')
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Error');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return loadingAnimation('Loading hashtags...');
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
                  child: RecipeHashtagCard(
                    hashtagDoc: snapshot.data!.docs[index],
                    collectionId: arguments.collectionDocId,
                  ),
                ),
              );
            }
            return const Text('Loading ...');
          },
        ),
      ),
    );
  }
}

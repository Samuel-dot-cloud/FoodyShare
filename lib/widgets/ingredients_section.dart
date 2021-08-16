import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_share/models/recipe_model.dart';

class Ingredients extends StatelessWidget {
  final DocumentSnapshot ingredientsDoc;

  const Ingredients({Key? key, required this.ingredientsDoc}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    String ingredient = 'test';
    List ingredientsList =
    ingredientsDoc['ingredients'].map((item) {
      item.forEach((key, value) => value = ingredient);
    })?.toList();
    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text('⚫ ' + ingredient),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return Divider(
                color: Colors.black.withOpacity(0.3),
              );
            },
            itemCount: ingredientsList.length,
            shrinkWrap: true,
            physics: const ScrollPhysics(),
          ),
        ],
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_share/models/recipe_model.dart';

class Ingredients extends StatelessWidget {
  final DocumentSnapshot ingredientsDoc;

  const Ingredients({Key? key, required this.ingredientsDoc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // List ingredients = ingredientsDoc['ingredients'];
    // ingredients.map((items) => items as Map).forEach((item) =>  item.values.forEach((string) => string.toString()));
    List ingredientsList =
    ingredientsDoc['ingredients'].map((item) => item as Map)?.toList();
    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text('⚫ ' + ingredientsList[index].values.toString()),
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

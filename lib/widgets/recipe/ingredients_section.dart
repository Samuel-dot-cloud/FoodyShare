import 'package:flutter/material.dart';

class IngredientsSection extends StatelessWidget {
  final List ingredients;

  const IngredientsSection({Key? key, required this.ingredients}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // List ingredients = ingredientsDoc['ingredients'];
    // ingredients.map((items) => items as Map).forEach((item) =>  item.values.forEach((string) => string.toString()));
    List? ingredientsList =
    ingredients.map((item) => item as Map).toList();


    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text('⚫ ' + ingredientsList[index].values.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                ),),
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

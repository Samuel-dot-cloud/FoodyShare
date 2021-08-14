import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:food_share/models/recipe_model.dart';

class RecipeNotifier with ChangeNotifier{
  // List<RecipeModel> _recipeList = [];
  // RecipeModel _currentRecipe = RecipeModel(
  //     id: '',
  //     title: '',
  //     writer: '',
  //     description: '',
  //     cookingTime: '',
  //     servings: '',
  //     ingredients: [],
  //     preparation: [],
  //     imgPath: '',
  //     createdAt: Timestamp.now(),
  // );
  //
  // UnmodifiableListView<RecipeModel> get recipeList => UnmodifiableListView(_recipeList);
  //
  // RecipeModel get currentRecipe => _currentRecipe;
  //
  // set recipeList(List<RecipeModel> recipeList){
  //   _recipeList = recipeList;
  //   notifyListeners();
  // }
  //
  // set currentRecipe(RecipeModel recipeModel){
  //   _currentRecipe = recipeModel;
  //   notifyListeners();
  // }
}
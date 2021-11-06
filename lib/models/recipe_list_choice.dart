import 'package:flutter/material.dart';

class RecipeListChoice {
  const RecipeListChoice({
    required this.title,
    required this.onTap,
  });

  final String title;
  final VoidCallback onTap;

  @override
  String toString() => title;
}

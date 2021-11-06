import 'package:cloud_firestore/cloud_firestore.dart';

class ListRecipesArguments {
  final DocumentSnapshot listDoc;

  ListRecipesArguments({
    required this.listDoc,
  });
}

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_share/routes/app_routes.dart';
import 'package:food_share/services/firebase_operations.dart';
import 'package:food_share/utils/form_values.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:food_share/widgets/create/recipe_form.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as image_plugin;
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CreateRecipe extends StatefulWidget {
  CreateRecipe({Key? key, required this.file}) : super(key: key);
  XFile file;

  // CustomUser? currentUser;

  @override
  State<CreateRecipe> createState() => _CreateRecipeState();
}

class _CreateRecipeState extends State<CreateRecipe> {
  late File photoFile;
  bool isUploading = false;
  String postId = const Uuid().v4();
  final Timestamp timestamp = Timestamp.now();
  final recipesRef = FirebaseFirestore.instance.collection('recipes');
  final usersRef = FirebaseFirestore.instance.collection('users');
  final hashtagsRef = FirebaseFirestore.instance.collection('hashtags');
  final collectionsRef = FirebaseFirestore.instance.collection('collections');
  firebase_storage.Reference reference =
      firebase_storage.FirebaseStorage.instance.ref();
  DocumentSnapshot? hashtagData;

  @override
  void initState() {
    photoFile = File(widget.file.path);
    super.initState();
  }

  Future<String> uploadImage(
      imageFile, firebase_storage.Reference reference) async {
    String urlString = '';
    firebase_storage.UploadTask task =
        reference.child('recipe-images/$postId.jpg').putFile(imageFile);
    await (task.whenComplete(() async {
      urlString = await task.snapshot.ref.getDownloadURL();
    }).catchError((onError) {
      Fluttertoast.showToast(
          msg: onError.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }));

    return urlString;
  }

  /// Adding recipes to hashtag collections
  processHashtags(String hashtagID, String postId) {
    return hashtagsRef.doc(hashtagID).get().then((value) {
      hashtagData = value;
    }).whenComplete(() async {
      return collectionsRef
          .doc(hashtagData!['collection_id'])
          .collection('hashtags')
          .doc(hashtagData!['hashtag_id'])
          .collection('recipes')
          .doc(postId)
          .set({
        'post_id': postId,
        'timestamp': timestamp,
      }).whenComplete(() async {
        return collectionsRef.doc(hashtagData!['collection_id']).update({
          'recipe_no': FieldValue.increment(1),
        });
      });
    });
  }

  createRecipePost(
      {required String mediaUrl,
      required String name,
      required String description,
      required String cookingTime,
      required String servings,
      required List<Map<String, String>> ingredients,
      required List<Map<String, String>> preparation,
      required List<String> hashtagID}) async {
    recipesRef.doc(postId).set({
      'postId': postId,
      'authorId':
          Provider.of<FirebaseOperations>(context, listen: false).getUserId,
      'mediaUrl': mediaUrl,
      'description': description,
      'name': name,
      'cookingTime': cookingTime,
      'servings': servings,
      'ingredients': ingredients,
      'preparation': preparation,
      'hashtags': hashtagID,
      'videoURL': '',
      'timestamp': timestamp,
    }).whenComplete(() async {
      return addRecipeDetails();
    }).whenComplete(() async {
      for (var id in hashtagID) {
        processHashtags(id, postId);
      }
    }).whenComplete(() async {
      setState(() {
        photoFile = File('');
        isUploading = false;
      });
      Fluttertoast.showToast(
          msg: 'Recipe uploaded successfully 👍🍲',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: kBlue,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pushReplacementNamed(context, AppRoutes.bottomNav);
    });
  }

  ///Adding recipe details to user collection to display in profile section
  Future addRecipeDetails() async {
    return usersRef
        .doc(Provider.of<FirebaseOperations>(context, listen: false).getUserId)
        .collection('recipes')
        .doc(postId)
        .set({
      'postId': postId,
      'timestamp': timestamp,
    }).whenComplete(() async {
      var doc = await usersRef
          .doc(
              Provider.of<FirebaseOperations>(context, listen: false).getUserId)
          .collection('counts')
          .doc('recipeCount')
          .get();
      if (doc.exists) {
        return usersRef
            .doc(Provider.of<FirebaseOperations>(context, listen: false)
                .getUserId)
            .collection('counts')
            .doc('recipeCount')
            .update({
          'count': FieldValue.increment(1),
        });
      } else {
        return usersRef
            .doc(Provider.of<FirebaseOperations>(context, listen: false)
                .getUserId)
            .collection('counts')
            .doc('recipeCount')
            .set({
          'count': FieldValue.increment(1),
        });
      }
    });
  }

  void _addRecipe(BuildContext context, FormValues values) async {
    setState(() {
      isUploading = true;
    });
    await compressImage();
    String mediaUrl = await uploadImage(photoFile, reference);
    createRecipePost(
      cookingTime: values.cookingTime.toString(),
      servings: values.servings.toString(),
      ingredients: values.ingredients!.toList(),
      preparation: values.preparation!.toList(),
      description: values.description.toString(),
      mediaUrl: mediaUrl,
      name: values.name.toString(),
      hashtagID: values.hashtagId!.toList(),
    );
  }

  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    image_plugin.Image? imageFile =
        image_plugin.decodeImage(photoFile.readAsBytesSync());
    final compressedImageFile = File('$path/img_$postId.jpg')
      ..writeAsBytesSync(image_plugin.encodeJpg(imageFile!, quality: 85));

    setState(() {
      photoFile = compressedImageFile;
    });
  }

  @override
  Widget build(BuildContext context) {
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
          'Add Recipe Details',
          style: kBodyText.copyWith(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverSafeArea(
            minimum: const EdgeInsets.all(15.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                isUploading
                    ? const LinearProgressIndicator(
                        backgroundColor: Colors.cyanAccent,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.yellow),
                      )
                    : const SizedBox(
                        height: 0.0,
                        width: 0.0,
                      ),
                SizedBox(
                  height: 220.0,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24.0),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: FileImage(photoFile),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                RecipeForm(
                  onSubmit: (FormValues values) {
                    _addRecipe(context, values);
                  },
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

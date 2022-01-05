import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_share/config/size_config.dart';
import 'package:food_share/routes/app_routes.dart';
import 'package:food_share/services/analytics_service.dart';
import 'package:food_share/services/firebase_operations.dart';
import 'package:food_share/utils/form_values.dart';
import 'package:food_share/utils/palette.dart';
import 'package:food_share/widgets/create/recipe_form.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as image_plugin;
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CreateRecipe extends StatefulWidget {
  const CreateRecipe({Key? key, required this.file}) : super(key: key);
  final XFile file;

  // CustomUser? currentUser;

  @override
  State<CreateRecipe> createState() => _CreateRecipeState();
}

class _CreateRecipeState extends State<CreateRecipe> {
  late File _photoFile;
  bool _isUploading = false;
  final String _postId = const Uuid().v4();
  final Timestamp _timestamp = Timestamp.now();
  final _recipesRef = FirebaseFirestore.instance.collection('recipes');
  final _usersRef = FirebaseFirestore.instance.collection('users');
  final _hashtagsRef = FirebaseFirestore.instance.collection('hashtags');
  final _collectionsRef = FirebaseFirestore.instance.collection('collections');
  final firebase_storage.Reference _reference =
      firebase_storage.FirebaseStorage.instance.ref();
  DocumentSnapshot? _hashtagData;

  @override
  void initState() {
    _photoFile = File(widget.file.path);
    super.initState();
  }

  Future<String> uploadImage(
      imageFile, firebase_storage.Reference reference) async {
    String urlString = '';
    firebase_storage.UploadTask task =
        reference.child('recipe-images/$_postId.jpg').putFile(imageFile);
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
    return _hashtagsRef.doc(hashtagID).get().then((value) {
      _hashtagData = value;
    }).whenComplete(() async {
      return _collectionsRef
          .doc(_hashtagData!['collection_id'])
          .collection('hashtags')
          .doc(_hashtagData!['hashtag_id'])
          .collection('recipes')
          .doc(postId)
          .set({
        'post_id': postId,
        'timestamp': _timestamp,
      }).whenComplete(() async {
        return _collectionsRef.doc(_hashtagData!['collection_id']).update({
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
    _recipesRef.doc(_postId).set({
      'postId': _postId,
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
      'timestamp': _timestamp,
    }).whenComplete(() async {
      return addRecipeDetails();
    }).whenComplete(() async {
      for (var id in hashtagID) {
        processHashtags(id, _postId);
      }
    }).whenComplete(() async {
      setState(() {
        _photoFile = File('');
        _isUploading = false;
      });
      Provider.of<AnalyticsService>(context, listen: false).logCreateRecipe(
          Provider.of<FirebaseOperations>(context, listen: false).getUsername);
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
    return _usersRef
        .doc(Provider.of<FirebaseOperations>(context, listen: false).getUserId)
        .collection('recipes')
        .doc(_postId)
        .set({
      'postId': _postId,
      'timestamp': _timestamp,
    }).whenComplete(() async {
      var doc = await _usersRef
          .doc(
              Provider.of<FirebaseOperations>(context, listen: false).getUserId)
          .collection('counts')
          .doc('recipeCount')
          .get();
      if (doc.exists) {
        return _usersRef
            .doc(Provider.of<FirebaseOperations>(context, listen: false)
                .getUserId)
            .collection('counts')
            .doc('recipeCount')
            .update({
          'count': FieldValue.increment(1),
        });
      } else {
        return _usersRef
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
      _isUploading = true;
    });
    await compressImage();
    String mediaUrl = await uploadImage(_photoFile, _reference);
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
        image_plugin.decodeImage(_photoFile.readAsBytesSync());
    final compressedImageFile = File('$path/img_$_postId.jpg')
      ..writeAsBytesSync(image_plugin.encodeJpg(imageFile!, quality: 85));

    setState(() {
      _photoFile = compressedImageFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    double size = SizeConfig.defaultSize;
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
                _isUploading
                    ? const LinearProgressIndicator(
                        backgroundColor: Colors.cyanAccent,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.yellow),
                      )
                    : const SizedBox(
                        height: 0.0,
                        width: 0.0,
                      ),
                const SizedBox(
                  height: 10.0,
                ),
                SizedBox(
                  height: size * 22.0,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24.0),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: FileImage(_photoFile),
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

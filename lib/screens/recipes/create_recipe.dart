import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_share/utils/form_values.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:food_share/widgets/create_recipe_page/recipe_form.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as image_plugin;
import 'package:uuid/uuid.dart';

class CreateRecipe extends StatefulWidget {
  CreateRecipe({Key? key, required this.file}) : super(key: key);
   XFile? file;

  @override
  State<CreateRecipe> createState() => _CreateRecipeState();
}

class _CreateRecipeState extends State<CreateRecipe> {

  File? photoFile;
  bool isUploading = false;
  String postId = const Uuid().v4();


  @override
  void initState() {
    // TODO: implement initState
    photoFile = File(widget.file!.path);
    super.initState();
  }

  uploadImage(imageFile) async{

  }


  void _addRecipe(BuildContext context, FormValues values) async {
    setState(() {
      isUploading = true;
    });
    await compressImage();
    await uploadImage(photoFile);
    //https://javascript.plainenglish.io/best-mobile-app-ideas-for-successful-business-in-2021-710c7efccd93?source=explore---------24-83--------------------4bd66714_50c9_47b0_89fe_8a28ec633d93-------15
  }

  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    image_plugin.Image? imageFile = image_plugin.decodeImage(photoFile!.readAsBytesSync());
    var compressedImageFile = File('$path/img_$postId.jpg')..writeAsBytesSync(image_plugin.encodeJpg(imageFile!, quality: 85));

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
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Add Recipe Details',
          style: kBodyText.copyWith(
            color: Colors.black,
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
                isUploading ? const LinearProgressIndicator(
                  backgroundColor: Colors.cyanAccent,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
                ) : const Text(''),
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
                                image: FileImage(photoFile!),
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

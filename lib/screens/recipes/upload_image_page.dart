import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_share/screens/recipes/create_recipe.dart';
import 'package:food_share/utils/palette.dart';
import 'package:food_share/widgets/rounded_button.dart';
import 'package:lottie/lottie.dart';
import 'package:image_picker/image_picker.dart';

class ImageUpload extends StatefulWidget {
  const ImageUpload({Key? key}) : super(key: key);


  @override
  _ImageUploadState createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  late XFile file;
  final ImagePicker _picker = ImagePicker();

  _handleTakePhoto() async {
    Navigator.pop(context);
     file = (await _picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 675.0,
      maxWidth: 960.0,
    ))!;
    setState(() {
      file = file;
    });
    photoCondition();
  }

  _handleChooseFromGallery() async {
    Navigator.pop(context);
    XFile? file = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      this.file = file!;
    });
    photoCondition();
  }

  photoCondition() {
    if (file == null) {
      Fluttertoast.showToast(
          msg: 'Something went wrong!!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: 'Image selected',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: kBlue,
          textColor: Colors.white,
          fontSize: 16.0);
      navigateToAddRecipeDetails();
    }
  }

  selectImage(parentContext) {
    return showDialog(
      context: parentContext,
      builder: (context) {
        return SimpleDialog(
          title: const Text(
            'Select recipe image',
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 15.0,
                right: 15.0,
              ),
              child: Divider(
                height: 2.0,
                color: Colors.grey[500],
                thickness: 1.0,
              ),
            ),
            SimpleDialogOption(
              child: const Text(
                'Image from camera',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              onPressed: _handleTakePhoto,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 15.0,
                right: 15.0,
              ),
              child: Divider(
                height: 2.0,
                color: Colors.grey[500],
                thickness: 1.0,
              ),
            ),
            SimpleDialogOption(
              child: const Text(
                'Image from gallery',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              onPressed: _handleChooseFromGallery,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 15.0,
                right: 15.0,
              ),
              child: Divider(
                height: 2.0,
                color: Colors.grey[500],
                thickness: 1.0,
              ),
            ),
            SimpleDialogOption(
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 15.0,
                right: 15.0,
              ),
              child: Divider(
                height: 2.0,
                color: Colors.grey[500],
                thickness: 1.0,
              ),
            ),
          ],
        );
      },
    );
  }

  navigateToAddRecipeDetails() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateRecipe(file: file)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: Text(
          'Add New Recipe',
          style: kBodyText.copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.50,
              width: MediaQuery.of(context).size.width * 0.90,
              child: Lottie.asset('assets/lottie/image_upload.json'),
            ),
            const SizedBox(
              height: 20.0,
            ),
            RoundedButton(
              buttonName: 'Select Image',
              onPressed: () => selectImage(context),
            ),
          ],
        ),
      ),
    );
  }
}

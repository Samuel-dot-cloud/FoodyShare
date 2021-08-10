import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_share/services/firebase_operations.dart';
import 'package:food_share/services/screens/sign_up_service.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class SignUpUtils with ChangeNotifier {
  final picker = ImagePicker();
  File userAvatar = File('');

  // late File userAvatarPhoto;
  File get getUserAvatar => userAvatar;

  String userAvatarUrl = '';

  String get getUserAvatarUrl => userAvatarUrl;

  Future pickUserAvatar(BuildContext context, ImageSource source) async {
    final pickedUserAvatar = await picker.pickImage(source: source);
    pickedUserAvatar == null
        ? Fluttertoast.showToast(
            msg: 'Select image',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.blue,
            textColor: Colors.white,
            fontSize: 16.0)
        : userAvatar = File(pickedUserAvatar.path);

    userAvatar != null
        ? Provider.of<FirebaseOperations>(context, listen: false)
            .uploadUserAvatar(context)
        : Fluttertoast.showToast(
            msg: 'Image upload error!!!',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);

    notifyListeners();
  }

  Future selectAvatarOptionsSheet(BuildContext context) async {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4.0,
                    color: Colors.white54,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      color: Colors.black,
                      child: const Text(
                        'Gallery',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      onPressed: () {
                        pickUserAvatar(context, ImageSource.gallery)
                            .whenComplete(() {
                          Navigator.pop(context);
                          Provider.of<SignUpService>(context, listen: false)
                              .showUserAvatar(context);
                        });
                      },
                    ),
                    MaterialButton(
                      color: Colors.black,
                      child: const Text(
                        'Camera',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      onPressed: () {
                        pickUserAvatar(context, ImageSource.camera)
                            .whenComplete(() {
                          Navigator.pop(context);
                          Provider.of<SignUpService>(context, listen: false)
                              .showUserAvatar(context);
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: kBlue,
              borderRadius: BorderRadius.zero,
            ),
          );
        });
  }
}

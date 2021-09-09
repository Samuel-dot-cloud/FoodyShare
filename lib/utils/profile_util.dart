import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_share/helpers/profile_helper.dart';
import 'package:food_share/services/firebase_operations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileUtils with ChangeNotifier {
  final picker = ImagePicker();
  File userAvatar = File('');

  File get getUserAvatar => userAvatar;


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
        ? Provider.of<ProfileHelper>(context, listen: false)
            .showSelectedUserAvatar(context, Provider.of<FirebaseOperations>(context).getUserId)
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

}

import 'package:flutter/material.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:food_share/utils/sign_up_util.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../firebase_operations.dart';

class SignUpService with ChangeNotifier {
  showUserAvatar(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.30,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 150.0),
                child: Divider(
                  thickness: 4.0,
                  color: Colors.white54,
                ),
              ),
              CircleAvatar(
                  radius: 80.0,
                  backgroundColor: Colors.grey,
                  backgroundImage: FileImage(
                      Provider.of<SignUpUtils>(context, listen: false)
                          .userAvatar),),
              SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        Provider.of<SignUpUtils>(context, listen: false).selectAvatarOptionsSheet(context);
                      },
                      child: const Text(
                        'Select',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white,
                        ),
                      ),
                    ),
                    MaterialButton(
                      color: kBlue,
                      onPressed: () {
                        Provider.of<FirebaseOperations>(context, listen: false).uploadUserAvatar(context).whenComplete(() {
                          Navigator.pop(context);
                        });
                      },
                      child: const Text(
                        'Confirm Image',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,

                        ),
                      ),
                    ),
                  ],

                ),
              ),
            ],
          ),
          decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.zero,
          ),
        );
      },
    );
  }
}

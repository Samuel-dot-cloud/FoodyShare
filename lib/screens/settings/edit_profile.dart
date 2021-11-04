import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_share/models/user_model.dart';
import 'package:food_share/services/firebase_operations.dart';
import 'package:food_share/helpers/profile_helper.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:food_share/utils/loading_animation.dart';
import 'package:provider/provider.dart';

final usersRef = FirebaseFirestore.instance.collection('users');

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  bool isObscuredPassword = true;
  bool _isLoading = false;
  bool _displayNameValid = true;
  bool _bioValid = true;

  CustomUser? currentUser;

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  getUserDetails() async {
    setState(() {
      _isLoading = true;
    });
    DocumentSnapshot doc = await usersRef
        .doc(Provider.of<FirebaseOperations>(context, listen: false).getUserId)
        .get();
    currentUser = CustomUser.fromDocument(doc);
    _displayNameController.text = currentUser!.displayName;
    _bioController.text = currentUser!.bio;
    setState(() {
      _isLoading = false;
    });
  }

  updateProfileData() {
    setState(() {
      _displayNameController.text.trim().length < 3 ||
              _displayNameController.text.isEmpty
          ? _displayNameValid = false
          : _displayNameValid = true;
      _bioController.text.trim().length > 75
          ? _bioValid = false
          : _bioValid = true;
    });

    if (_displayNameValid && _bioValid) {
      usersRef
          .doc(
              Provider.of<FirebaseOperations>(context, listen: false).getUserId)
          .update({
        'bio': _bioController.text,
        'displayName': _displayNameController.text,
      });

      SnackBar snackBar = const SnackBar(
        content: Text('Profile details updated'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Provider.of<FirebaseOperations>(context, listen: false)
          .initUserData(context);
    }
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
          'Edit Profile',
          style: kBodyText.copyWith(
            fontSize: 25.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: !_isLoading
          ? Container(
              padding:
                  const EdgeInsets.only(left: 15.0, top: 20.0, right: 15.0),
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: ListView(
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 130.0,
                            height: 120.0,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 4.0,
                                color: Colors.white,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  spreadRadius: 2.0,
                                  blurRadius: 10.0,
                                  color: Colors.black.withOpacity(0.1),
                                ),
                              ],
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: CachedNetworkImageProvider(
                                    Provider.of<FirebaseOperations>(context,
                                            listen: false)
                                        .getUserImage),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0.0,
                            right: 0.0,
                            child: GestureDetector(
                              onTap: () {
                                Provider.of<ProfileHelper>(context,
                                        listen: false)
                                    .showProfileUserAvatar(
                                        context,
                                        Provider.of<FirebaseOperations>(context,
                                                listen: false)
                                            .getUserId);
                              },
                              child: Container(
                                height: 40.0,
                                width: 40.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    width: 4.0,
                                    color: Colors.white,
                                  ),
                                  color: kBlue,
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    buildTextField(
                      labelText: 'Display Name',
                      isPasswordTextField: false,
                      controller: _displayNameController,
                      errorText:
                          _displayNameValid ? '' : 'Display name too short',
                    ),
                    buildTextField(
                      labelText: 'Bio',
                      isPasswordTextField: false,
                      controller: _bioController,
                      errorText: _bioValid ? '' : 'Bio too long',
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'CANCEL',
                            style: TextStyle(
                              fontSize: 15.0,
                              letterSpacing: 2.0,
                              color: Colors.black,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                20.0,
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            updateProfileData();
                          },
                          child: const Text(
                            'UPDATE',
                            style: TextStyle(
                              fontSize: 15.0,
                              letterSpacing: 2.0,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: kBlue,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                20.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          : loadingAnimation('Loading profile details...'),
    );
  }

  Widget buildTextField(
      {required TextEditingController controller,
      required String labelText,
      required String errorText,
      required bool isPasswordTextField}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: TextField(
        controller: controller,
        obscureText: isPasswordTextField ? isObscuredPassword : false,
        decoration: InputDecoration(
          suffixIcon: isPasswordTextField
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      isObscuredPassword = !isObscuredPassword;
                    });
                  },
                  icon: const Icon(
                    Icons.remove_red_eye,
                    color: Colors.grey,
                  ),
                )
              : null,
          contentPadding: const EdgeInsets.only(bottom: 5.0),
          labelText: labelText,
          errorText: errorText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
      ),
    );
  }
}

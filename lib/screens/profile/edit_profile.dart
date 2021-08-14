import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_share/models/user_model.dart';
import 'package:food_share/screens/auth/login_screen.dart';
import 'package:food_share/services/auth_service.dart';
import 'package:food_share/services/firebase_operations.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:food_share/viewmodel/loading_animation.dart';
import 'package:provider/provider.dart';

final usersRef = FirebaseFirestore.instance.collection('users');

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  bool isObscuredPassword = true;
  bool _isLoading = false;
  bool _displayNameValid = true;
  bool _bioValid = true;
  bool _usernameValid = true;

  CustomUser? currentUser;

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  getUserDetails() async {
    setState(() {
      _isLoading = true;
    });
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    final uid = user!.uid;
    DocumentSnapshot doc = await usersRef.doc(uid).get();
    currentUser = CustomUser.fromDocument(doc);
    _usernameController.text = currentUser!.username;
    _displayNameController.text = currentUser!.displayName;
    _bioController.text = currentUser!.bio;
    setState(() {
      _isLoading = false;
    });
  }

  updateProfileData() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    final uid = user!.uid;
    setState(() {
      _usernameController.text.trim().length < 3 ||
              _usernameController.text.trim().length > 12 ||
              _usernameController.text.isEmpty
          ? _usernameValid = false
          : _usernameValid = true;
      _displayNameController.text.trim().length < 3 ||
              _displayNameController.text.isEmpty
          ? _displayNameValid = false
          : _displayNameValid = true;
      _bioController.text.trim().length > 100
          ? _bioValid = false
          : _bioValid = true;
    });

    if (_usernameValid && _displayNameValid && _bioValid) {
      usersRef.doc(uid).update({
        'bio': _bioController.text,
        'displayName': _displayNameController.text,
        'username': _usernameController.text,
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
        backgroundColor: kBlue,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Edit Profile',
          style: kBodyText,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<AuthService>(context, listen: false).logOut();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ],
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
                                image: NetworkImage(
                                    Provider.of<FirebaseOperations>(context,
                                            listen: false)
                                        .getUserImage),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0.0,
                            right: 0.0,
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
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    buildTextField(
                      labelText: 'Username',
                      isPasswordTextField: false,
                      controller: _usernameController,
                      errorText: _usernameValid
                          ? ''
                          : 'Username should be 3 to 12 characters long',
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
          // hintText: placeholder,
          // hintStyle: const TextStyle(
          //   fontSize: 16.0,
          //   fontWeight: FontWeight.bold,
          //   color: Colors.grey,
          // ),
        ),
      ),
    );
  }
}
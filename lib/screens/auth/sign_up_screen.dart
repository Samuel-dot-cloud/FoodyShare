import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_share/models/user_model.dart';
import 'package:food_share/services/auth_service.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:food_share/viewmodel/bottom_nav.dart';
import 'package:food_share/widgets/background_image.dart';
import 'package:food_share/widgets/rounded_button.dart';
import 'package:food_share/widgets/text_input_field.dart';

final Reference storageRef = FirebaseStorage.instance.ref();
final usersRef = FirebaseFirestore.instance.collection('users');
final recipesRef = FirebaseFirestore.instance.collection('recipes');

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _usernameController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  final DateTime timestamp = DateTime.now();
  late CustomUser currentUser;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        const BackgroundImage(image: 'assets/images/img-6.jpg'),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: isLoading == false
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.width * 0.1,
                      ),
                      Stack(
                        children: [
                          Center(
                            child: ClipOval(
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 3,
                                  sigmaY: 3,
                                ),
                                child: CircleAvatar(
                                  backgroundColor:
                                      Colors.grey[400]!.withOpacity(0.4),
                                  radius: size.width * 0.14,
                                  child: Icon(
                                    FontAwesomeIcons.user,
                                    color: kWhite,
                                    size: size.width * 0.1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: size.height * 0.08,
                            left: size.width * 0.56,
                            child: Container(
                              height: size.width * 0.1,
                              width: size.width * 0.1,
                              decoration: BoxDecoration(
                                color: kBlue,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: kWhite,
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                FontAwesomeIcons.arrowUp,
                                color: kWhite,
                                size: size.width * 0.06,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: size.width * 0.1,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextInputField(
                              icon: FontAwesomeIcons.at,
                              hint: 'Username',
                              obscure: true,
                              inputType: TextInputType.name,
                              action: TextInputAction.next,
                              controller: _usernameController,
                              validator: (value) {
                                if (value.trim().length < 3 || value.isEmpty) {
                                  return 'Username too short';
                                } else if (value.trim().length > 12) {
                                  return 'Username too long';
                                } else {
                                  return null;
                                }
                              },
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                            ),
                            TextInputField(
                              icon: FontAwesomeIcons.user,
                              hint: 'Display name',
                              obscure: false,
                              inputType: TextInputType.name,
                              action: TextInputAction.next,
                              controller: _displayNameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please input your display name';
                                }
                                return null;
                              },
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                            ),
                            TextInputField(
                              icon: FontAwesomeIcons.envelope,
                              hint: 'Email',
                              obscure: false,
                              inputType: TextInputType.emailAddress,
                              action: TextInputAction.next,
                              controller: _emailController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please input your email address';
                                }
                                return null;
                              },
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                            ),
                            TextInputField(
                              icon: FontAwesomeIcons.lock,
                              hint: 'Password',
                              obscure: true,
                              inputType: TextInputType.name,
                              action: TextInputAction.next,
                              controller: _passwordController,
                              validator: (value) {
                                if (value.trim().length < 6 || value.isEmpty) {
                                  return 'Please input password that is more than 6 characters long';
                                }
                                return null;
                              },
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                            ),
                            const SizedBox(
                              height: 25.0,
                            ),
                            RoundedButton(
                              buttonName: 'Register',
                              onPressed: () async {
                                setState(() {
                                  isLoading = true;
                                });
                                if (_formKey.currentState!.validate()) {
                                  AuthService()
                                      .createAccount(_emailController.text,
                                          _passwordController.text)
                                      .then((value) async {
                                    createUserInFirestore();
                                    if (value == 'Account created') {
                                      setState(() {
                                        isLoading = false;
                                      });
                                      Fluttertoast.showToast(
                                          msg: value,
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0);

                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const BottomNav()),
                                          (route) => false);
                                    } else {
                                      setState(() {
                                        isLoading = false;
                                      });
                                      Fluttertoast.showToast(
                                          msg: value,
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    }
                                  });
                                }
                              },
                            ),
                            const SizedBox(
                              height: 30.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Already have an account? ',
                                  style: kBodyText,
                                ),
                                GestureDetector(
                                  onTap: () =>
                                      Navigator.pushNamed(context, 'login'),
                                  child: Text(
                                    'Login',
                                    style: kBodyText.copyWith(
                                      color: kBlue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.cyanAccent,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
                  ),
                ),
        ),
      ],
    );
  }

  createUserInFirestore() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user!.uid;

    DocumentSnapshot doc = await usersRef.doc(uid).get();
    if (!doc.exists) {
      final String username = _usernameController.text;
      final String displayName = _displayNameController.text;
      final String email = _emailController.text;
      usersRef.doc(uid).set({
        'id': uid,
        'username': username,
        'email': email,
        'photoUrl': '',
        'displayName': displayName,
        'bio': '',
        'timestamp': timestamp
      });

      doc = await usersRef.doc(uid).get();
    }

    currentUser = CustomUser.fromDocument(doc);
  }
}

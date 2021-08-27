import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_share/models/user_model.dart';
import 'package:food_share/services/auth_service.dart';
import 'package:food_share/services/firebase_operations.dart';
import 'package:food_share/services/screens/sign_up_service.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:food_share/utils/sign_up_util.dart';
import 'package:food_share/viewmodel/bottom_nav.dart';
import 'package:food_share/widgets/background_image.dart';
import 'package:food_share/widgets/rounded_button.dart';
import 'package:food_share/widgets/text_input_field.dart';
import 'package:provider/provider.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
CustomUser? currentUser;
final Timestamp timestamp = Timestamp.now();

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

  bool isLoading = false;
  bool _emailValid = true;
  bool _passwordValid = true;
  bool _displayNameValid = true;
  bool _usernameValid = true;

  registerUser() async {
    setState(() {
      _emailController.text.trim().isEmpty
          ? _emailValid = false
          : _emailValid = true;
      _passwordController.text.trim().length < 6 ||
              _passwordController.text.isEmpty
          ? _passwordValid = false
          : _passwordValid = true;
      _usernameController.text.trim().length < 3 ||
              _usernameController.text.trim().length > 14 ||
              _usernameController.text.isEmpty
          ? _usernameValid = false
          : _usernameValid = true;
      _displayNameController.text.trim().length < 3 ||
              _displayNameController.text.isEmpty
          ? _displayNameValid = false
          : _displayNameValid = true;
    });

    if (_emailValid && _passwordValid && _usernameValid && _displayNameValid) {
      setState(() {
        isLoading = true;
      });
      final DocumentSnapshot result = await Future.value(FirebaseFirestore
          .instance
          .collection('usernames')
          .doc(_usernameController.text.toLowerCase())
          .get());
      if (result.exists) {
        Fluttertoast.showToast(
            msg: '@${_usernameController.text.toLowerCase()} already exists',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        setState(() {
          isLoading = false;
        });
      } else {
        Fluttertoast.showToast(
            msg: 'Username is available',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        AuthService()
            .createAccount(
                context,
                _emailController.text,
                _passwordController.text,
                _usernameController.text.toLowerCase(),
                _displayNameController.text)
            .then((value) {
          if (value == 'Account created') {
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(
                msg: value,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const BottomNav()),
                (route) => false);
          } else {
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(
                msg: value,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        });
      }
    }
  }

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
                                  backgroundImage: FileImage(
                                      Provider.of<SignUpUtils>(context,
                                              listen: false)
                                          .getUserAvatar),
                                  radius: size.width * 0.14,
                                  // ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: size.height * 0.08,
                            left: size.width * 0.56,
                            child: GestureDetector(
                              onTap: () {
                                Provider.of<SignUpService>(context,
                                        listen: false)
                                    .showUserAvatar(context);
                              },
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
                                  FontAwesomeIcons.upload,
                                  color: kWhite,
                                  size: size.width * 0.06,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: size.width * 0.1,
                      ),
                      Column(
                        children: [
                          TextInputField(
                            icon: FontAwesomeIcons.at,
                            label: 'Username',
                            obscure: false,
                            inputType: TextInputType.name,
                            action: TextInputAction.next,
                            controller: _usernameController,
                            errorText: _usernameValid
                                ? ''
                                : 'Username should be 3 to 14 characters long',
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp("[@]")),
                            ],
                          ),
                          TextInputField(
                            icon: FontAwesomeIcons.user,
                            label: 'Display name',
                            obscure: false,
                            inputType: TextInputType.name,
                            action: TextInputAction.next,
                            controller: _displayNameController,
                            errorText: _displayNameValid
                                ? ''
                                : 'Display name too short',
                            inputFormatters: const [],
                          ),
                          TextInputField(
                            icon: FontAwesomeIcons.envelope,
                            label: 'Email',
                            obscure: false,
                            inputType: TextInputType.emailAddress,
                            action: TextInputAction.next,
                            controller: _emailController,
                            errorText: _emailValid
                                ? ''
                                : 'Please input a valid email address',
                            inputFormatters: const [],
                          ),
                          TextInputField(
                            icon: FontAwesomeIcons.lock,
                            label: 'Password',
                            obscure: true,
                            inputType: TextInputType.name,
                            action: TextInputAction.next,
                            controller: _passwordController,
                            errorText: _passwordValid
                                ? ''
                                : 'Password should be more than 6 characters long',
                            inputFormatters: const [],
                          ),
                          const SizedBox(
                            height: 25.0,
                          ),
                          RoundedButton(
                            buttonName: 'Register',
                            onPressed: () {
                              registerUser();
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
}

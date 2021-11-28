import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_share/routes/app_routes.dart';
import 'package:food_share/services/analytics_service.dart';
import 'package:food_share/services/auth_service.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:food_share/widgets/auth/background_image.dart';
import 'package:food_share/widgets/rounded_button.dart';
import 'package:food_share/widgets/auth/text_input_field.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

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

  bool _isLoading = false;
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
        _isLoading = true;
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
          _isLoading = false;
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
              _isLoading = false;
            });
            Provider.of<AnalyticsService>(context, listen: false).logSignUp();
            Fluttertoast.showToast(
                msg: value,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0);
            Navigator.pushReplacementNamed(context, AppRoutes.startupView);
          } else {
            setState(() {
              _isLoading = false;
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
    Size _size = MediaQuery.of(context).size;
    return Stack(
      children: [
        const BackgroundImage(image: 'assets/images/img-6.jpg'),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: _isLoading == false
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: _size.width * 0.1,
                      ),
                      Stack(
                        children: [
                          Center(
                            child: Container(
                              width: _size.width * 0.38,
                              height: _size.height * 0.18,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(100.0),
                                ),
                              ),
                              child: Lottie.asset(
                                  'assets/lottie/profile-icon.json'),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: _size.width * 0.1,
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
                              Text(
                                'Already have an account? ',
                                style: kBodyText.copyWith(color: Colors.white),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.pushNamed(
                                    context, AppRoutes.login),
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

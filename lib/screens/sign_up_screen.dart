import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:food_share/widgets/background_image.dart';
import 'package:food_share/widgets/rounded_button.dart';
import 'package:food_share/widgets/text_input_field.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        const BackgroundImage(image: 'assets/images/img-6.jpg'),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
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
                            backgroundColor: Colors.grey[400]!.withOpacity(0.4),
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
                Column(
                  children: [
                    const TextInputField(
                      icon: FontAwesomeIcons.user,
                      hint: 'Username',
                      obscure: false,
                      inputType: TextInputType.name,
                      action: TextInputAction.next,
                    ),
                    const TextInputField(
                      icon: FontAwesomeIcons.envelope,
                      hint: 'Email',
                      obscure: false,
                      inputType: TextInputType.emailAddress,
                      action: TextInputAction.next,
                    ),
                    const TextInputField(
                      icon: FontAwesomeIcons.lock,
                      hint: 'Password',
                      obscure: true,
                      inputType: TextInputType.name,
                      action: TextInputAction.next,
                    ),
                    const TextInputField(
                      icon: FontAwesomeIcons.lock,
                      hint: 'Confirm Password',
                      obscure: true,
                      inputType: TextInputType.name,
                      action: TextInputAction.next,
                    ),
                    const SizedBox(
                      height: 25.0,
                    ),
                    const RoundedButton(buttonName: 'Register'),
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
                          onTap: () => Navigator.pushNamed(context, '/'),
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
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:food_share/widgets/background_image.dart';
import 'package:food_share/widgets/rounded_button.dart';
import 'package:food_share/widgets/text_input_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BackgroundImage(image: 'assets/images/img-1.jpg'),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              Flexible(
                child: Center(
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(context, 'home'),
                    child: const Text(
                      'FoodyShare',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 60.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextInputField(
                    hint: 'Email',
                    icon: FontAwesomeIcons.envelope,
                    action: TextInputAction.next,
                    inputType: TextInputType.emailAddress,
                    obscure: false,
                    controller: _emailController,
                  ),
                  TextInputField(
                    hint: 'Password',
                    icon: FontAwesomeIcons.lock,
                    action: TextInputAction.done,
                    inputType: TextInputType.name,
                    obscure: true,
                    controller: _passwordController,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, 'ForgotPassword'),
                    child: const Text(
                      'Forgot Password?',
                      style: kBodyText,
                    ),
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  RoundedButton(
                    buttonName: 'Login',
                    onPressed: () {  },
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, 'SignUp'),
                child: Container(
                  child: const Text(
                    'Create A New Account',
                    style: kBodyText,
                  ),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 1.0, color: kWhite),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

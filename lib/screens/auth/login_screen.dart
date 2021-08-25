import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_share/services/auth_service.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:food_share/viewmodel/bottom_nav.dart';
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
  bool _emailValid = true;
  bool _passwordValid = true;

  bool isLoading = false;

  loginUser() {
    setState(() {
      _emailController.text.trim().isEmpty
          ? _emailValid = false
          : _emailValid = true;
      _passwordController.text.trim().length < 6 ||
              _passwordController.text.isEmpty
          ? _passwordValid = false
          : _passwordValid = true;
    });

    if (_emailValid && _passwordValid) {
      setState(() {
        isLoading = true;
      });
      AuthService()
          .loginUser(_emailController.text, _passwordController.text)
          .then((value) {
        if (value == 'Welcome') {
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BackgroundImage(image: 'assets/images/img-5.jpg'),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: isLoading == false
              ? Column(
                  children: [
                    const Flexible(
                      child: Center(
                        child: Text(
                          'FoodyShare',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 60.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextInputField(
                          label: 'Email',
                          icon: FontAwesomeIcons.envelope,
                          action: TextInputAction.next,
                          inputType: TextInputType.emailAddress,
                          obscure: false,
                          controller: _emailController,
                          errorText: _emailValid
                              ? ''
                              : 'Please input a valid email address',
                        ),
                        TextInputField(
                          label: 'Password',
                          icon: FontAwesomeIcons.lock,
                          action: TextInputAction.done,
                          inputType: TextInputType.name,
                          obscure: true,
                          controller: _passwordController,
                          errorText: _passwordValid
                              ? ''
                              : 'Password should be more than six characters long',
                        ),
                        GestureDetector(
                          onTap: () =>
                              Navigator.pushNamed(context, 'ForgotPassword'),
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
                          onPressed: () {
                            loginUser();
                          },
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

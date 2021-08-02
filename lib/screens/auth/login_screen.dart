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

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BackgroundImage(image: 'assets/images/img-1.jpg'),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: isLoading == false
              ? Column(
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
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });
                            if( _emailController.text != '' && _passwordController.text != '' ){
                              AuthService().loginUser(_emailController.text, _passwordController.text).then((value) {
                                if (value == 'Welcome'){
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
                                      fontSize: 16.0
                                  );
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
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                  );
                                }
                              });
                            }
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

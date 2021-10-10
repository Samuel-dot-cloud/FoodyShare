import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_share/routes/app_routes.dart';
import 'package:food_share/services/auth_service.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:food_share/widgets/auth/background_image.dart';
import 'package:food_share/widgets/rounded_button.dart';
import 'package:food_share/widgets/auth/text_input_field.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _emailController = TextEditingController();
  bool _emailValid = true;

  bool isLoading = false;

  resetPassword() {
    setState(() {
      _emailController.text.trim().isEmpty
          ? _emailValid = false
          : _emailValid = true;
    });

    if (_emailValid) {
      setState(() {
        isLoading = true;
      });
      AuthService().resetPassword(_emailController.text).then((value) {
        if (value == 'Reset email sent') {
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
          Navigator.pushReplacementNamed(context, AppRoutes.login);
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
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        const BackgroundImage(image: 'assets/images/img-2.jpg'),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: kWhite,
              ),
            ),
            title: const Text(
              'Forgot Password',
              style: kBodyText,
            ),
            centerTitle: true,
          ),
          body: isLoading == false
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      Center(
                        child: Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.1,
                            ),
                            SizedBox(
                              width: size.width * 0.8,
                              child: const Text(
                                'Enter your email address for which instructions to '
                                'reset your password shall be sent.',
                                style: kBodyText,
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            TextInputField(
                              icon: FontAwesomeIcons.envelope,
                              label: 'Email',
                              obscure: false,
                              inputType: TextInputType.emailAddress,
                              action: TextInputAction.done,
                              controller: _emailController,
                              errorText: _emailValid
                                  ? ''
                                  : 'Please input an email address',
                              inputFormatters: const [],
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            RoundedButton(
                              buttonName: 'Send',
                              onPressed: () {
                                resetPassword();
                              },
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
}

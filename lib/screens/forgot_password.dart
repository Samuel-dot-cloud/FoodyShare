import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:food_share/widgets/background_image.dart';
import 'package:food_share/widgets/rounded_button.dart';
import 'package:food_share/widgets/text_input_field.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        const BackgroundImage(image: 'assets/images/img-3.jpg'),
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
          body: SingleChildScrollView(
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
                      const TextInputField(
                        icon: FontAwesomeIcons.envelope,
                        hint: 'Email',
                        obscure: false,
                        inputType: TextInputType.emailAddress,
                        action: TextInputAction.done,
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      const RoundedButton(buttonName: 'Send'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

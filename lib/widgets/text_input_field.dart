import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_share/utils/pallete.dart';

class TextInputField extends StatelessWidget {
  final IconData icon;
  final String hint;
  final bool obscure;
  final TextInputType inputType;
  final TextInputAction action;

  const TextInputField({
    Key? key,
    required this.icon,
    required this.hint,
    required this.obscure,
    required this.inputType,
    required this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
      ),
      child: Container(
        height: size.height * 0.08,
        width: size.width * 0.8,
        decoration: BoxDecoration(
          color: Colors.grey[500]!.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Center(
          child: TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                ),
                child: Icon(
                  icon,
                  size: 28.0,
                  color: kWhite,
                ),
              ),
              hintText: hint,
              hintStyle: kBodyText,
            ),
            obscureText: obscure,
            style: kBodyText,
            keyboardType: inputType,
            textInputAction: action,
          ),
        ),
      ),
    );
  }
}

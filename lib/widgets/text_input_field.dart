import 'package:flutter/material.dart';
import 'package:food_share/utils/pallete.dart';

class TextInputField extends StatefulWidget {
  final IconData icon;
  final String label;
  final String errorText;
  final bool obscure;
  final TextInputType inputType;
  final TextInputAction action;
  final TextEditingController controller;

  const TextInputField({
    Key? key,
    required this.icon,
    required this.label,
    required this.obscure,
    required this.inputType,
    required this.action,
    required this.controller,
    required this.errorText,
  }) : super(key: key);

  @override
  State<TextInputField> createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
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
                  vertical: 20.0,
                ),
                child: Icon(
                  widget.icon,
                  size: 28.0,
                  color: kWhite,
                ),
              ),
              labelText: widget.label,
              labelStyle: kBodyText,
              floatingLabelBehavior: FloatingLabelBehavior.never,
              errorText: widget.errorText,
              errorStyle: const TextStyle(
                fontSize: 15.0,
              ),
            ),
            obscureText: widget.obscure,
            controller: widget.controller,
            style: const TextStyle(
              color: Colors.white,
            ),
            keyboardType: widget.inputType,
            textInputAction: widget.action,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:food_share/utils/palette.dart';

class RoundedButton extends StatelessWidget {
  final String buttonName;
  final GestureTapCallback onPressed;

  const RoundedButton({
    Key? key,
    required this.buttonName,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Container(
      height: _size.height * 0.08,
      width: _size.width * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: kBlue,
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          buttonName,
          style: kBodyText.copyWith(
            color: Colors.white,
              fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:food_share/utils/pallete.dart';

class SettingsMenu extends StatelessWidget {
  const SettingsMenu({
    Key? key,
    required this.size,
    required this.text,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  final Size size;
  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 10.0,
      ),
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
              Colors.grey[500]!.withOpacity(0.5)),
          padding:
              MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(20.0)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0))),
        ),
        onPressed: onPressed,
        child: Row(
          children: [
            Icon(
              icon,
              size: 30.0,
              color: kBlue,
            ),
            SizedBox(
              width: size.width * 0.05,
            ),
            Expanded(
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                      fontSize: 17.0,
                    ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}

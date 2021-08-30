import 'package:flutter/material.dart';
import 'package:food_share/config/size_config.dart';
import 'package:simple_animations/simple_animations.dart';

class MyAnimatedContainer extends StatelessWidget {
  const MyAnimatedContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlayAnimation<double>(
      builder: (context, child, value){
        return Container(
          width: value,
          height: value,
          decoration: const BoxDecoration(
            color: Colors.yellowAccent,
            image: DecorationImage(
                image: AssetImage('assets/images/welcome.png'),
            ),
          ),
        );
      },
        tween: Tween(
          begin: 0.0,
          end: SizeConfig.orientation == Orientation.portrait ? SizeConfig.screenHeight : SizeConfig.screenWidth,
        ),
      duration: const Duration(seconds: 1),
      curve: Curves.easeOut,
    );
  }
}

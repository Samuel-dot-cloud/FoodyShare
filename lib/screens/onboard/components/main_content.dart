import 'package:flutter/material.dart';
import 'package:food_share/config/size_config.dart';
import 'package:food_share/models/onboarding_model.dart';
import 'package:food_share/screens/onboard/animations/fade_animation.dart';

class MainContent extends StatelessWidget {
  const MainContent(
      {Key? key, required List<OnboardingModel> list, required this.index})
      : _list = list,
        super(key: key);

  final List<OnboardingModel> _list;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(SizeConfig.defaultSize * 2),
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: FadeAnimation(
              0.5,
              Image.asset(
                _list[index].image,
                height: SizeConfig.defaultSize * 30,
                width: SizeConfig.defaultSize * 30,
              ),
            ),
          ),
          FadeAnimation(
            0.9,
            Text(
              _list[index].title,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: SizeConfig.defaultSize * 2.6,
              ),
            ),
          ),
          SizedBox(
            height: SizeConfig.defaultSize,
          ),
          FadeAnimation(
            1.1,
            Text(
              _list[index].text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w400,
                fontSize: SizeConfig.defaultSize * 1.8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

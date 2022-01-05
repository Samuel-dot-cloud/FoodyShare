import 'package:flutter/material.dart';
import 'package:food_share/config/size_config.dart';
import 'package:food_share/models/onboarding_model.dart';
import 'package:food_share/utils/palette.dart';

class SkipButton extends StatelessWidget {
  const SkipButton({
    Key? key,
    required this.page,
    required this.list,
    required this.controller,
    required this.showGetStartedCallBack,
  }) : super(key: key);

  final int page;
  final List<OnboardingModel> list;
  final PageController controller;
  final Function showGetStartedCallBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(SizeConfig.defaultSize),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
            onTap: () {
              if (page < list.length && page != list.length - 2) {
                controller.animateToPage(list.length + 1,
                    duration: const Duration(microseconds: 500),
                    curve: Curves.easeInCirc);
                showGetStartedCallBack(true);
              }
            },
            child: Text(
              'Skip',
              style: TextStyle(
                color: kBlue,
                fontSize: SizeConfig.defaultSize * 1.8, // 14
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

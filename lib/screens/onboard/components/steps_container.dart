import 'package:flutter/material.dart';
import 'package:food_share/config/size_config.dart';
import 'package:food_share/models/onboarding_model.dart';
import 'package:food_share/utils/pallete.dart';

class StepsContainer extends StatelessWidget {
  const StepsContainer(
      {Key? key,
        required this.page,
        required this.list,
        required this.controller,
        required this.showGetStartedCallBack})
      : super(key: key);

  final int page;
  final List<OnboardingModel> list;
  final PageController controller;
  final Function showGetStartedCallBack;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig.defaultSize * 4.5,
      height: SizeConfig.defaultSize * 4.5,
      child: Stack(
        children: [
          SizedBox(
            width: SizeConfig.defaultSize * 4.5,
            height: SizeConfig.defaultSize * 4.5,
            child: CircularProgressIndicator(
              valueColor: const AlwaysStoppedAnimation<Color>(kBlue),
              value: (page + 1) / (list.length + 1),
            ),
          ),
          Center(
            child: InkWell(
              child: Container(
                width: SizeConfig.defaultSize * 3.5,
                height: SizeConfig.defaultSize * 3.5,
                decoration: const BoxDecoration(
                  color: kBlue,
                  borderRadius: BorderRadius.all(
                    Radius.circular(100.0),
                  ),
                ),
                child: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                ),
              ),
              onTap: () {
                if (page < list.length && page != list.length - 1) {
                  controller.animateToPage(page + 1,
                      duration: const Duration(microseconds: 500),
                      curve: Curves.easeInCirc);
                  showGetStartedCallBack(false);
                } else {
                  showGetStartedCallBack(true);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

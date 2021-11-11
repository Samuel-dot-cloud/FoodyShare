import 'package:flutter/material.dart';
import 'package:food_share/config/size_config.dart';
import 'package:food_share/models/onboarding_model.dart';
import 'package:food_share/services/analytics_service.dart';
import 'package:food_share/viewmodel/main.dart';
import 'package:food_share/widgets/rounded_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/main_content.dart';
import 'components/skip_button.dart';
import 'components/steps_container.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final List<OnboardingModel> _list = OnboardingModel.list;
  int page = 0;
  final _controller = PageController();
  var showGetStartedButton = false;
  late final Function showAnimatedContainerCallBack;

  @override
  void initState() {
    Provider.of<AnalyticsService>(context, listen: false).logOnboardBegin();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _storeOnboardInfo() async {
    int isViewed = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('onboard', isViewed);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    _controller.addListener(() {
      setState(() {
        page = _controller.page!.round();
      });
    });
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
           SafeArea(
                  child: Column(
                    children: [
                      SkipButton(
                        page: page,
                        list: _list,
                        controller: _controller,
                        showGetStartedCallBack: (value) {
                          setState(() {
                            showGetStartedButton = value;
                          });
                        },

                      ),
                      Expanded(
                        child: PageView.builder(
                          controller: _controller,
                          itemCount: _list.length,
                          itemBuilder: (context, index) => MainContent(
                            list: _list,
                            index: index,
                          ),
                        ),
                      ),
                      showGetStartedButton ? RoundedButton(
                          buttonName: 'Get Started', onPressed: () async {
                            await _storeOnboardInfo();
                            Provider.of<AnalyticsService>(context, listen: false).logOnboardComplete();
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Home()));
                      }) : StepsContainer(
                          page: page,
                          list: _list,
                          controller: _controller,
                          showGetStartedCallBack: (value) {
                            setState(() {
                              showGetStartedButton = value;
                            });
                          },),
                      SizedBox(
                        height: SizeConfig.defaultSize * 4.0,
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}

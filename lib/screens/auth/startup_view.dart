import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:food_share/config/size_config.dart';
import 'package:food_share/routes/app_routes.dart';
import 'package:food_share/services/firebase_operations.dart';
import 'package:food_share/utils/constants.dart';
import 'package:food_share/utils/palette.dart';
import 'package:food_share/utils/purchase_api.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class StartupView extends StatelessWidget {
  const StartupView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    double _size = SizeConfig.defaultSize;

    FirebaseAuth _auth = FirebaseAuth.instance;

    Provider.of<FirebaseOperations>(context, listen: false)
        .initUserData(context)
        .whenComplete(() => Future.delayed(
                const Duration(
                  milliseconds: 1000,
                ), () async {
              if (_auth.currentUser == null) {
                WidgetsBinding.instance?.addPostFrameCallback((_) {
                  Navigator.pushReplacementNamed(context, AppRoutes.login);
                });
              } else {
                WidgetsBinding.instance?.addPostFrameCallback((_) async {
                  await PurchaseAPI.init(context);
                  Navigator.pushReplacementNamed(context, AppRoutes.bottomNav);
                });
              }
            }));

    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.60,
              width: MediaQuery.of(context).size.width,
              child: Lottie.asset('assets/lottie/splash.json'),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  Constants.appName,
                  style: TextStyle(
                    color: kBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: _size * 2.8,
                  ),
                ),
                Text(
                  ' setting up...',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: _size * 2.5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_share/routes/app_routes.dart';
import 'package:food_share/services/firebase_operations.dart';
import 'package:food_share/utils/constants.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class StartupView extends StatelessWidget {
  const StartupView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;

    Provider.of<FirebaseOperations>(context, listen: false)
        .initUserData(context)
        .whenComplete(() => Future.delayed(
                const Duration(
                  milliseconds: 3000,
                ), () {
              if (auth.currentUser == null) {
                Navigator.pushReplacementNamed(context, AppRoutes.login);
              } else {
                Navigator.pushReplacementNamed(context, AppRoutes.bottomNav);
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
              children: const [
                Text(
                  Constants.appName,
                  style: TextStyle(
                    color: kBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 28.0,
                  ),
                ),
                Text(
                  ' setting up...',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 25.0,
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

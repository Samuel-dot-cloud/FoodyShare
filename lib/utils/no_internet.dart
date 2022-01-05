import 'package:flutter/material.dart';
import 'package:food_share/utils/palette.dart';
import 'package:lottie/lottie.dart';

class NoInternet extends StatelessWidget {
  const NoInternet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              child: Lottie.asset('assets/lottie/no-internet-connection.json'),
            ),
            const SizedBox(
              height: 20.0,
            ),
            const Text(
              'No internet connection!!!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: kBlue,
                fontWeight: FontWeight.w600,
                fontSize: 27.0,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Padding(
                padding: EdgeInsets.all(20.0),
            child: Text(
              'Please ensure Wi-Fi or mobile data is on.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: 25.0,
              ),
            ),
            ),
          ],
        ),
      ),
    );
  }
}

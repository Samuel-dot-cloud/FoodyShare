import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ActivityFeedHelper with ChangeNotifier{

  defaultNoNotification(BuildContext context, String text) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.60,
              width: MediaQuery.of(context).size.width * 0.80,
              child: Lottie.asset('assets/lottie/no-feed.json'),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text(
              text,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 23.0,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
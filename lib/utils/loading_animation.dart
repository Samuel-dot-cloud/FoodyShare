import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

loadingAnimation(String text) {
  return Center(
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 300.0,
            width: 300.0,
            child: Lottie.asset('assets/lottie/loading.json'),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Text(
            text,
            style: const TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}

import 'package:flutter/material.dart';

class NumberFormatter {
  static String formatter(String currentValue) {
    try {
      double value = double.parse(currentValue);

      if (value < 1000) {
        // Less than a thousand
        return value.toStringAsFixed(0);
      } else if (value >= 1000 && value < (1000 * 100 * 10)) {
        // Less than a million
        double result = value / 1000;
        return result.toStringAsFixed(1) + 'K';
      } else if (value >= 1000000 && value < (1000000 * 10 * 100)) {
        // less than 100 million
        double result = value / 1000000;
        return result.toStringAsFixed(2) + 'M';
      } else if (value >= (1000000 * 10 * 100) &&
          value < (1000000 * 10 * 100 * 100)) {
        // less than 100 billion
        double result = value / (1000000 * 10 * 100);
        return result.toStringAsFixed(2) + 'B';
      } else if (value >= (1000000 * 10 * 100 * 100) &&
          value < (1000000 * 10 * 100 * 100 * 100)) {
        // less than 100 trillion
        double result = value / (1000000 * 10 * 100 * 100);
        return result.toStringAsFixed(2) + 'T';
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return '';
  }
}

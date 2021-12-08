import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_share/services/firebase_operations.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/offering_wrapper.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PurchaseAPI {
  static const _apiKey = 'zuUgyyekRJkvknVRqAymIkkovAlRaUre';

  static Future init(BuildContext context) async {
    await Purchases.setDebugLogsEnabled(true);
    // await Purchases.setup(_apiKey);
    await Purchases.setup(_apiKey, appUserId: Provider.of<FirebaseOperations>(context, listen: false).getUserId);
  }

  static Future logout() async {
    await Purchases.logOut();
  }

  static Future<List<Offering>> fetchOffers() async {
    try {
      final offerings = await Purchases.getOfferings();
      final current = offerings.current;

      return current == null ? [] : [current];
    } on PlatformException {
      return [];
    }
  }

  static Future<bool> purchasePackage(Package package) async {
    try {
      await Purchases.purchasePackage(package);
      return true;
    } catch (e) {
      return false;
    }
  }
}

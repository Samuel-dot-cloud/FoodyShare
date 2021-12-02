import 'package:flutter/material.dart';
import 'package:food_share/models/entitlement.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class RevenueCatProvider extends ChangeNotifier {
  RevenueCatProvider() {
    init();
  }

  Entitlement _entitlement = Entitlement.free;

  Entitlement get entitlement => _entitlement;

  Future init() async {
    Purchases.addPurchaserInfoUpdateListener((purchaserInfo) async {
      updatePurchaseStatus();
    });
  }

  Future updatePurchaseStatus() async {
    final purchaseInfo = await Purchases.getPurchaserInfo();

    final entitlements = purchaseInfo.entitlements.active.values.toList();
    _entitlement =
        entitlements.isEmpty ? Entitlement.free : Entitlement.allRecipes;

    notifyListeners();
  }
}

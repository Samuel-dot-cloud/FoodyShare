import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_share/models/entitlement.dart';
import 'package:food_share/routes/app_routes.dart';
import 'package:food_share/services/auth_service.dart';
import 'package:food_share/services/firebase_operations.dart';
import 'package:food_share/services/revenuecat_provider.dart';
import 'package:food_share/utils/constants.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:food_share/utils/purchase_api.dart';
import 'package:food_share/widgets/profile/settings_menu.dart';
import 'package:food_share/widgets/settings/paywall_widget.dart';
import 'package:food_share/widgets/settings/theme_options.dart';
import 'package:provider/provider.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    final _entitlement = Provider.of<RevenueCatProvider>(context, listen: true).entitlement;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Settings',
          style: kBodyText.copyWith(
            fontSize: 25.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: _size.height * 0.15,
              width: _size.width * 0.3,
              child: CircleAvatar(
                backgroundColor: kBlue,
                backgroundImage: CachedNetworkImageProvider(
                    Provider.of<FirebaseOperations>(context, listen: false)
                        .getUserImage),
              ),
            ),
            SizedBox(
              height: _size.height * 0.02,
            ),
            InkWell(
              onTap: () => _fetchOffers(context),
              child: Container(
                height: _size.height * 0.06,
                width: _size.width * 0.50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.orangeAccent,
                ),
                child: Center(
                  child: Text(
                    _entitlement == Entitlement.free ? 'Upgrade to PRO 💳' : 'PRO member 🎁',
                    style: kBodyText.copyWith(fontSize: 18.0),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: _size.height * 0.02,
            ),
            SettingsMenu(
              size: _size,
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.editProfile);
              },
              text: 'Edit Profile',
              icon: Icons.person,
            ),
            SettingsMenu(
              size: _size,
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(15.0),
                      ),
                    ),
                    builder: (context) {
                      return SizedBox(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Padding(
                              padding: EdgeInsets.only(
                                left: 20.0,
                                top: 20.0,
                                bottom: 20.0,
                              ),
                              child: Text(
                                'Set Theme:',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(child: ThemeOptions())
                          ],
                        ),
                      );
                    });
              },
              text: 'Themes',
              icon: FontAwesomeIcons.palette,
            ),
            SettingsMenu(
              size: _size,
              onPressed: () {
                _fetchOffers(context);
              },
              text: 'In App Payments',
              icon: Icons.monetization_on_outlined,
            ),
            SettingsMenu(
              size: _size,
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.about);
              },
              text: 'About ' + Constants.appName,
              icon: Icons.info_outline,
            ),
            SettingsMenu(
              size: _size,
              onPressed: () async {
                Provider.of<AuthService>(context, listen: false).logOut();
                await PurchaseAPI.logout();
                Navigator.pushReplacementNamed(context, AppRoutes.login);
              },
              text: 'Log out',
              icon: Icons.logout,
            ),
          ],
        ),
      ),
    );
  }

  Future _fetchOffers(BuildContext context) async {
    final offerings = await PurchaseAPI.fetchOffers();

    if (offerings.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Billing service error 🤖‼'),
      ));
    } else {
      final packages = offerings
          .map((offer) => offer.availablePackages)
          .expand((pair) => pair)
          .toList();

      showModalBottomSheet(
          context: context,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(15.0),
            ),
          ),
          builder: (context) => PaywallWidget(
              title: '⭐ Upgrade Your Plan',
              description:
                  'Upgrade to pro membership to access more app features',
              packages: packages,
              onClickedPackage: (package) async {
                await PurchaseAPI.purchasePackage(package);
                Navigator.pop(context);
              }));
    }
  }
}

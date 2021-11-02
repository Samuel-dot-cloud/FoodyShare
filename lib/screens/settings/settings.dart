import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_share/routes/app_routes.dart';
import 'package:food_share/services/auth_service.dart';
import 'package:food_share/services/firebase_operations.dart';
import 'package:food_share/utils/constants.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:food_share/widgets/profile/settings_menu.dart';
import 'package:food_share/widgets/settings/theme_options.dart';
import 'package:provider/provider.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
              height: size.height * 0.15,
              width: size.width * 0.3,
              child: CircleAvatar(
                backgroundColor: kBlue,
                backgroundImage: CachedNetworkImageProvider(
                    Provider.of<FirebaseOperations>(context, listen: false)
                        .getUserImage),
              ),
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            SettingsMenu(
              size: size,
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.editProfile);
              },
              text: 'Edit Profile',
              icon: Icons.person,
            ),
            SettingsMenu(
              size: size,
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(15.0),
                      ),
                    ),
                    builder: (context){
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
                            'Choose Theme Option:',
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
              size: size,
              onPressed: () {},
              text: 'In App Payments',
              icon: Icons.monetization_on_outlined,
            ),
            SettingsMenu(
              size: size,
              onPressed: () {
                showLicensePage(
                  context: context,
                  applicationName: Constants.appName,
                  applicationVersion: '0.0.1',
                  applicationLegalese: 'Copyright Samuel Wahome',
                  applicationIcon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/icons/launch_image.png',
                      width: 48.0,
                      height: 48.0,
                    ),
                  ),
                );
              },
              text: 'About ' + Constants.appName,
              icon: Icons.info_outline,
            ),
            SettingsMenu(
              size: size,
              onPressed: () {
                Provider.of<AuthService>(context, listen: false).logOut();
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
}

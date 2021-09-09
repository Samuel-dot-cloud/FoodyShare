import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_share/routes/app_routes.dart';
import 'package:food_share/services/auth_service.dart';
import 'package:food_share/services/firebase_operations.dart';
import 'package:food_share/utils/constants.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:food_share/widgets/profile/settings_menu.dart';
import 'package:provider/provider.dart';

class ProfileSettings extends StatelessWidget {
  const ProfileSettings({Key? key}) : super(key: key);

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
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Settings',
          style: kBodyText.copyWith(
            color: Colors.black,
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
                backgroundImage: NetworkImage(
                  Provider.of<FirebaseOperations>(context, listen: false)
                      .getUserImage,
                ),
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
              onPressed: () {},
              text: 'General',
              icon: FontAwesomeIcons.tools,
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

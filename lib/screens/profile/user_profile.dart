import 'package:flutter/material.dart';
import 'package:food_share/routes/app_routes.dart';
import 'package:food_share/services/firebase_operations.dart';
import 'package:food_share/helpers/profile_helper.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  int itemsNumber = 10;
  double hPadding = 40.0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SlidingUpPanel(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
        minHeight: size.height * 0.36,
        maxHeight: size.height * 0.75,
        parallaxEnabled: true,
        body: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Hero(
                  tag: Provider.of<FirebaseOperations>(context, listen: false)
                      .getUserImage,
                  child: Image(
                    height: (size.height / 2) + 50,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        Provider.of<FirebaseOperations>(context, listen: false)
                            .getUserImage),
                  ),
                ),
              ),
            ],
          ),
        ),
        panel: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: hPadding),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(
                    height: 10.0,
                  ),
                  Provider.of<ProfileHelper>(context, listen: false)
                      .titleSection(
                          Provider.of<FirebaseOperations>(context,
                                  listen: false)
                              .getDisplayName,
                          Provider.of<FirebaseOperations>(context,
                                  listen: false)
                              .getUsername,
                          Provider.of<FirebaseOperations>(context,
                                  listen: false)
                              .getUserBio),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Provider.of<ProfileHelper>(context, listen: false)
                      .infoSection(
                          context,
                          Provider.of<FirebaseOperations>(context,
                                  listen: false)
                              .getUserId),
                  const SizedBox(
                    height: 12.0,
                  ),
                  _actionSection(hPadding: hPadding),
                ],
              ),
            ),

            ///Post Gridview
            Expanded(
              child: SingleChildScrollView(
                child: Provider.of<ProfileHelper>(context, listen: false)
                    .userRecipeGridViewPosts(
                        context,
                        Provider.of<FirebaseOperations>(context, listen: false)
                            .getUserId,
                        itemsNumber),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///Action section
  Container _actionSection({required double hPadding}) {
    return Container(
      alignment: Alignment.center,
      child: SizedBox(
        width: double.infinity,
        child: TextButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.settings);
          },
          child: const Text(
            'SETTINGS',
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            backgroundColor: MaterialStateProperty.all<Color>(kBlue),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
                side: const BorderSide(color: kBlue),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

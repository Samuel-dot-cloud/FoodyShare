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
  bool _isOpen = false;
  int itemsNumber = 10;

  final PanelController _panelController = PanelController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          FractionallySizedBox(
            alignment: Alignment.topCenter,
            heightFactor: 0.7,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      Provider.of<FirebaseOperations>(context, listen: false)
                          .getUserImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          FractionallySizedBox(
            alignment: Alignment.bottomCenter,
            heightFactor: 0.3,
            child: Container(
              color: Colors.white,
            ),
          ),

          /// Sliding panel
          SlidingUpPanel(
            controller: _panelController,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(32.0),
              topRight: Radius.circular(32.0),
            ),
            minHeight: size.height * 0.35,
            maxHeight: size.height * 0.75,
            body: GestureDetector(
              onTap: () => _panelController.close(),
              child: Container(
                color: Colors.transparent,
              ),
            ),
            panelBuilder: (ScrollController controller) =>
                _panelBody(controller),
            onPanelSlide: (value) {
              if (value >= 0.2) {
                if (!_isOpen) {
                  setState(() {
                    _isOpen = true;
                  });
                }
              }
            },
            onPanelClosed: () {
              setState(() {
                _isOpen = false;
              });
            },
          ),
        ],
      ),
    );
  }

  ///Panel body
  SingleChildScrollView _panelBody(ScrollController controller) {
    double hPadding = 40.0;

    return SingleChildScrollView(
      controller: controller,
      physics: const ScrollPhysics(),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: hPadding),
            height: MediaQuery.of(context).size.height * 0.35,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _titleSection(),
                Provider.of<ProfileHelper>(context, listen: false).infoSection(
                    context,
                    Provider.of<FirebaseOperations>(context, listen: false)
                        .getUserId),
                _actionSection(hPadding: hPadding),
              ],
            ),
          ),

          ///Post Gridview
          Provider.of<ProfileHelper>(context, listen: false)
              .userRecipeGridViewPosts(
                  context,
                  Provider.of<FirebaseOperations>(context, listen: false)
                      .getUserId,
                  itemsNumber),
        ],
      ),
    );
  }

  ///Action section
  Row _actionSection({required double hPadding}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Visibility(
          visible: !_isOpen,
          child: Expanded(
            child: OutlinedButton(
              onPressed: () => _panelController.open(),
              child: const Text(
                'VIEW PROFILE',
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    side: const BorderSide(color: kBlue),
                  ),
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: !_isOpen,
          child: const SizedBox(
            width: 16.0,
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.center,
            child: SizedBox(
              width: _isOpen
                  ? (MediaQuery.of(context).size.width - (2 * hPadding)) / 1.6
                  : double.infinity,
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
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
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
          ),
        ),
      ],
    );
  }

  ///Title section
  Column _titleSection() {
    return Column(
      children: [
        Text(
          Provider.of<FirebaseOperations>(context, listen: false)
              .getDisplayName,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 27.0,
          ),
        ),
        const SizedBox(
          height: 1.0,
        ),
        Text(
          '@' +
              Provider.of<FirebaseOperations>(context, listen: false)
                  .getUsername,
          style: const TextStyle(
            fontStyle: FontStyle.normal,
            fontSize: 22.0,
            color: Colors.grey,
          ),
        ),
        const SizedBox(
          height: 3.0,
        ),
        Text(
          "\"" +
              Provider.of<FirebaseOperations>(context, listen: false)
                  .getUserBio +
              "\"",
          style: GoogleFonts.robotoMono(
            textStyle: const TextStyle(
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w300,
              fontSize: 14.0,
            ),
          ),
        ),
      ],
    );
  }
}

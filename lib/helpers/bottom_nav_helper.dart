import 'package:cached_network_image/cached_network_image.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_share/services/firebase_operations.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:provider/provider.dart';

class BottomNavHelper with ChangeNotifier {
  Widget bottomNavigationBar(
      BuildContext context, int index, PageController pageController) {
    return CurvedNavigationBar(
      index: index,
      animationCurve: Curves.bounceIn,
      backgroundColor: kBlue,
      color: Theme.of(context).scaffoldBackgroundColor,
      animationDuration: const Duration(
        milliseconds: 200,
      ),
      height: 75.0,
      onTap: (val) {
        index = val;
        pageController.jumpToPage(val);
        notifyListeners();
      },
      items: [
        const FaIcon(
          FontAwesomeIcons.home,
          size: 20.0,
        ),
        const FaIcon(
          FontAwesomeIcons.search,
          size: 20.0,
        ),
        const FaIcon(
          FontAwesomeIcons.utensils,
          size: 20.0,
        ),
        const FaIcon(
          FontAwesomeIcons.solidBell,
          size: 20.0,
        ),
        CircleAvatar(
          radius: 16.5,
          backgroundColor: kBlue,
          backgroundImage: CachedNetworkImageProvider(
              Provider.of<FirebaseOperations>(context, listen: true)
                  .getUserImage),
        ),
      ],
    );
  }
}

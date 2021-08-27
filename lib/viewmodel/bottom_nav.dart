import 'package:flutter/material.dart';
import 'package:food_share/helpers/bottom_nav_helper.dart';
import 'package:food_share/screens/activity_feed.dart';
import 'package:food_share/screens/auth/sign_up_screen.dart';
import 'package:food_share/screens/home_page.dart';
import 'package:food_share/screens/search_page.dart';
import 'package:food_share/screens/profile/user_profile.dart';
import 'package:food_share/services/connectivity_provider.dart';
import 'package:food_share/services/firebase_operations.dart';
import 'package:food_share/utils/no_internet.dart';
import 'package:food_share/widgets/create_recipe_page/upload_image_page.dart';
import 'package:provider/provider.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  @override
  void initState() {
    Provider.of<FirebaseOperations>(context, listen: false)
        .initUserData(context);
    super.initState();
  }

  final PageController _homepageController = PageController();
  int _pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return appUI();
  }

  Widget appUI() {
    return Consumer<ConnectivityProvider>(
      builder: (context, model, child) {
        return model.isOnline
            ? Scaffold(
                backgroundColor: Colors.white,
                body: PageView(
                  controller: _homepageController,
                  children: const [
                    HomePage(),
                    SearchPage(),
                    ImageUpload(),
                    ActivityFeed(),
                    UserProfile(),
                  ],
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (page) {
                    setState(() {
                      _pageIndex = page;
                    });
                  },
                ),
                bottomNavigationBar:
                    Provider.of<BottomNavHelper>(context, listen: false)
                        .bottomNavigationBar(
                            context, _pageIndex, _homepageController),
              )
            : const NoInternet();
      },
    );
  }
}

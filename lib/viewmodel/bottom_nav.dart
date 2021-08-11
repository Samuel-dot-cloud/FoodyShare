import 'package:flutter/material.dart';
import 'package:food_share/helpers/bottom_nav_helper.dart';
import 'package:food_share/screens/auth/sign_up_screen.dart';
import 'package:food_share/screens/home_page.dart';
import 'package:food_share/screens/search_page.dart';
import 'package:food_share/screens/user_profile.dart';
import 'package:food_share/services/firebase_operations.dart';
import 'package:food_share/widgets/create_recipe_page/upload_image_page.dart';
import 'package:provider/provider.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  final PageController _homepageController = PageController();
  int _pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        controller: _homepageController,
        children: [
          const HomePage(),
          const SearchPage(),
          const ImageUpload(),
          UserProfile(profileId: currentUser?.id),
        ],
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (page) {
          setState(() {
            _pageIndex = page;
          });
        },
      ),
      bottomNavigationBar: Provider.of<BottomNavHelper>(context, listen: false)
          .bottomNavigationBar(context, _pageIndex, _homepageController),
    );
  }
}

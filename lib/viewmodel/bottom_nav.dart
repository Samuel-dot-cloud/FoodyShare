import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_share/screens/recipes/create_recipe.dart';
import 'package:food_share/screens/home_page.dart';
import 'package:food_share/screens/search_page.dart';
import 'package:food_share/screens/user_profile.dart';
import 'package:food_share/widgets/create_recipe_page/upload_image_page.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    const SearchPage(),
    const ImageUpload(),
    // const CreateRecipe(),
    const UserProfile(),
  ];

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        height: 75.0,
        index: _selectedIndex,
        onTap: _onItemTap,
        items: const [
          FaIcon(
            FontAwesomeIcons.home,
            color: Colors.black,
            size: 20.0,
          ),
          FaIcon(
            FontAwesomeIcons.search,
            color: Colors.black,
            size: 20.0,
          ),
          FaIcon(
            FontAwesomeIcons.utensils,
            color: Colors.black,
            size: 20.0,
          ),
          FaIcon(
            FontAwesomeIcons.user,
            size: 20.0,
          ),
        ],
        animationDuration: const Duration(
          milliseconds: 200,
        ),
        animationCurve: Curves.bounceInOut,
      ),
    );
  }
}
